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

# Define the service configuration
# https://developer.hashicorp.com/consul/api-docs/agent/service#register-service
service_config='
{
  "name": "prometheus",
  "address": "prometheus",
  "port": 9090,
  "meta": {
    "env": "production"
  },
  "checks": [
    {
      "http": "http://prometheus:9090/-/healthy",
      "interval": "1s"
    }
  ]
}'

# Register the service with Consul
curl --request PUT --data "$service_config" http://localhost:8500/v1/agent/service/register?replace-existing-checks=true
# curl http://localhost:8500/v1/catalog/services

# Query the 'up' metric from Prometheus. This metric indicates the health of the targets.
# If the target is up and healthy, the value is 1. Otherwise, the value is 0.
curl "http://127.0.0.1:9090/api/v1/query?query=up"
