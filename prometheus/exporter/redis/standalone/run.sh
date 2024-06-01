#!/bin/bash

set -e
set -v
set -x
set -u

cd "$(dirname "$0")"

DOCKER_COMPOSE=$(command -v docker-compose 2>/dev/null || echo "docker compose")

"$DOCKER_COMPOSE" up -d

# wait_for_services() {
#   "$DOCKER_COMPOSE" up -d

#   local services
#   services=$("$DOCKER_COMPOSE" config --services)

#   for service in $services; do
#     echo "Waiting for $service to be healthy..."
#     while [ "$(docker inspect --format='{{.State.Health.Status}}' "$("$DOCKER_COMPOSE" ps -q "$service")")" != "healthy" ]; do
#       sleep 2
#     done
#   done
# }

# wait_for_services

# Download redis_exporter Grafana dashboard
# DASHBOARD_URL="https://raw.githubusercontent.com/oliver006/redis_exporter/master/contrib/grafana_prometheus_redis_dashboard.json"
# DASHBOARD_FILE="./startup-config/grafana/dashboards/redis_dashboard.json"
# if [ ! -f "$DASHBOARD_FILE" ]; then
#   curl -L -o "$DASHBOARD_FILE" "$DASHBOARD_URL"
# fi

# Query the 'up' metric from Prometheus. This metric indicates the health of the targets.
# If the target is up and healthy, the value is 1. Otherwise, the value is 0.
curl "http://127.0.0.1:9090/api/v1/query?query=up"
