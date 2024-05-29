#!/bin/bash

set -e
set -v
set -x
set -u

DOCKER_COMPOSE=$(command -v docker-compose 2>/dev/null || echo "docker compose")
REDIS_MASTER_CLI="docker-compose exec redis-master redis-cli"
REDIS_SLAVE_CLI="docker-compose exec redis-slave redis-cli"

cd "$(dirname "$0")"

"$DOCKER_COMPOSE" up -d

wait_for_services() {
  "$DOCKER_COMPOSE" up -d

  local services
  services=$("$DOCKER_COMPOSE" config --services)

  for service in $services; do
    echo "Waiting for $service to be healthy..."
    while [ "$(docker inspect --format='{{.State.Health.Status}}' "$("$DOCKER_COMPOSE" ps -q "$service")")" != "healthy" ]; do
      sleep 2
    done
  done
}

wait_for_services

# Set 'foo' on master, get it from slave
eval "$REDIS_MASTER_CLI set foo bar"
eval "$REDIS_SLAVE_CLI get foo"

# Fetch replication info
eval "$REDIS_MASTER_CLI" INFO REPLICATION
eval "$REDIS_SLAVE_CLI" INFO REPLICATION
