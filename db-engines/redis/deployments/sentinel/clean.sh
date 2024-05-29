#!/bin/bash

set -e
set -v
set -u
set -x

DOCKER_COMPOSE=$(command -v docker-compose 2>/dev/null || echo "docker compose")

cd "$(dirname "$0")"

if [ -f docker-compose.yaml ]; then
  "$DOCKER_COMPOSE" rm -sfv
fi

rm -f docker-compose.yaml sentinel.conf
