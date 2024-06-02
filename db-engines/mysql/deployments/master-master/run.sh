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
run_docker_compose exec mysql-master-1 mysql -uroot -prootpassword -e "DROP USER IF EXISTS 'repl'@'%'; CREATE USER 'repl'@'%' IDENTIFIED WITH mysql_native_password BY 'replpassword'; GRANT REPLICATION SLAVE ON *.* TO 'repl'@'%';"
run_docker_compose exec mysql-master-2 mysql -uroot -prootpassword -e "DROP USER IF EXISTS 'repl'@'%'; CREATE USER 'repl'@'%' IDENTIFIED WITH mysql_native_password BY 'replpassword'; GRANT REPLICATION SLAVE ON *.* TO 'repl'@'%';"

# Executes the "SHOW MASTER STATUS;" SQL command on the mysql-master-1 service, and stores the File and Position values in the master_1_file and master_1_position variables.
output1=$(run_docker_compose exec -T mysql-master-1 mysql -uroot -prootpassword -e "SHOW MASTER STATUS;" | awk 'NR==2 {print $1, $2}')
master_1_file=$(echo "$output1" | cut -d' ' -f1)
master_1_position=$(echo "$output1" | cut -d' ' -f2)
echo "$master_1_file"
echo "$master_1_position"
output2=$(run_docker_compose exec -T mysql-master-2 mysql -uroot -prootpassword -e "SHOW MASTER STATUS;" | awk 'NR==2 {print $1, $2}')
master_2_file=$(echo "$output2" | cut -d' ' -f1)
master_2_position=$(echo "$output2" | cut -d' ' -f2)

# Configures MySQL replication between mysql-master-1 and mysql-master-2 services by setting each as the other's master and starting the slave process.
run_docker_compose exec -T mysql-master-2 mysql -uroot -prootpassword -e "
STOP SLAVE;
CHANGE MASTER TO MASTER_HOST = 'mysql-master-1', MASTER_USER = 'repl', MASTER_PASSWORD = 'replpassword', MASTER_LOG_FILE = \"$master_1_file\", MASTER_LOG_POS = $master_1_position;
START SLAVE;
"
run_docker_compose exec -T mysql-master-1 mysql -uroot -prootpassword -e "
STOP SLAVE;
CHANGE MASTER TO MASTER_HOST = 'mysql-master-2', MASTER_USER = 'repl', MASTER_PASSWORD = 'replpassword', MASTER_LOG_FILE = \"$master_2_file\", MASTER_LOG_POS = $master_2_position;
START SLAVE;
"

# Test
run_docker_compose exec -T mysql-master-2 mysql -uroot -prootpassword -e "
USE demo;
CREATE TABLE dummy (id VARCHAR(10));
DELIMITER $$
CREATE PROCEDURE InsertRandomData()
BEGIN
  DECLARE i INT DEFAULT 0;
  WHILE i < 10 DO
    INSERT INTO dummy (id) SELECT LPAD(FLOOR(RAND() * 1000000000), 10, '0') WHERE NOT EXISTS (SELECT * FROM dummy WHERE id = LPAD(FLOOR(RAND() * 1000000000), 10, '0'));
    SET i = i + 1;
  END WHILE;
END$$
DELIMITER ;
CALL InsertRandomData();
DROP PROCEDURE IF EXISTS InsertRandomData;
"
