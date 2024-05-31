#!/bin/bash

set -e
set -v
set -x
set -u

cd "$(dirname "$0")"

DOCKER_COMPOSE=$(command -v docker-compose 2>/dev/null || echo "docker compose")

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

# 查询 'up' 指标的当前值
curl "http://127.0.0.1:9090/api/v1/query?query=up"
