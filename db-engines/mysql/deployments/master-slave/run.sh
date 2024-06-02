#!/bin/bash

set -euvo pipefail

run_docker_compose() {
  if command -v docker-compose &>/dev/null; then
    docker-compose "$@" # Use hyphenated version
  elif command -v docker compose &>/dev/null; then
    docker compose "$@" # Use space-separated version
  else
    echo "Error: Neither 'docker-compose' nor 'docker compose' found."
    exit 1 # Exit the script with an error code
  fi
}

# Get the directory of the current script
script_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
cd "$script_dir"

# Start the Prometheus and Redis exporter
run_docker_compose up -d

wait_for_services() {
  local services
  services=$(run_docker_compose config --services)

  for service in $services; do
    echo "Waiting for $service to be healthy..."
    while [ "$(docker inspect --format='{{.State.Health.Status}}' "$(run_docker_compose ps -q "$service")")" != "healthy" ]; do
      sleep 2
    done
  done
}

wait_for_services

# Create replication user
run_docker_compose exec mysql-master mysql -uroot -prootpassword -e "DROP USER IF EXISTS 'repl'@'%'; CREATE USER 'repl'@'%' IDENTIFIED WITH mysql_native_password BY 'replpassword'; GRANT REPLICATION SLAVE ON *.* TO 'repl'@'%';"

# Backup the master
# https://dev.mysql.com/doc/refman/8.0/en/mysqldump.html
run_docker_compose exec -T mysql-master mysqldump -uroot -prootpassword --flush-logs --single-transaction --master-data=2 --all-databases >dump.sql

# Stop the slave if it's already running
run_docker_compose exec -T mysql-slave mysql -uroot -prootpassword -e "STOP SLAVE;" || true

# Restore data on the slave
run_docker_compose exec -T mysql-slave mysql -uroot -prootpassword <dump.sql

# Get master status
read -r master_log_file master_log_pos < <(run_docker_compose exec -T mysql-master mysql -uroot -prootpassword -e "SHOW MASTER STATUS" | tail -n +2)
echo "Master log file: $master_log_file"
echo "Master log position: $master_log_pos"

# Configure replication on the slave
CHANGE_MASTER_SQL="CHANGE MASTER TO MASTER_HOST='mysql-master', MASTER_USER='repl', MASTER_PASSWORD='replpassword', MASTER_LOG_FILE=\"$master_log_file\", MASTER_LOG_POS=$master_log_pos;"
if ! run_docker_compose exec -T mysql-slave mysql -uroot -prootpassword -e "$CHANGE_MASTER_SQL"; then
  echo "Error configuring replication on slave. Check MySQL logs." >&2
  exit 1
fi

# Start replication
if ! run_docker_compose exec -T mysql-slave mysql -uroot -prootpassword -e "START SLAVE;"; then
  echo "Error starting replication on slave. Check MySQL logs." >&2
  exit 1
fi

# Set slave as read only
if ! run_docker_compose exec -T mysql-slave mysql -uroot -prootpassword -e "SET GLOBAL read_only = ON;"; then
  echo "Error setting slave as read only. Check MySQL logs." >&2
  exit 1
fi

echo "Replication setup complete!"

# Insert some data into the master
run_docker_compose exec mysql-master mysql -uroot -prootpassword -e "CREATE DATABASE IF NOT EXISTS test;"
run_docker_compose exec mysql-master mysql -uroot -prootpassword -e "CREATE TABLE IF NOT EXISTS test.users (id INT PRIMARY KEY AUTO_INCREMENT, name VARCHAR(255));"
run_docker_compose exec mysql-master mysql -uroot -prootpassword -e "INSERT INTO test.users (name) VALUES ('Alice'), ('Bob'), ('Charlie');"
