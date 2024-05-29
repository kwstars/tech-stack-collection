#!/bin/bash

set -e
set -v
set -u

DOCKER_COMPOSE=$(command -v docker-compose 2>/dev/null || echo "docker compose")

cd "$(dirname "$0")"

"$DOCKER_COMPOSE" rm -sfv
