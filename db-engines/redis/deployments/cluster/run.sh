#!/bin/bash

set -euo pipefail

script_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
cd "$script_dir"

echo "Please enter the IP of the physical machine:"
read -r machine_ip
echo "The IP you entered is: $machine_ip"

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

wait_for_services() {
  run_docker_compose up -d

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

# Create the cluster
run_docker_compose exec redis-node-0 redis-cli --cluster create \
  "$machine_ip":7000 \
  "$machine_ip":7001 \
  "$machine_ip":7002 \
  "$machine_ip":7003 \
  "$machine_ip":7004 \
  "$machine_ip":7005 \
  --cluster-replicas 1 --cluster-yes

# Check the cluster status
run_docker_compose exec -it redis-node-0 redis-cli -p 7000 cluster info
