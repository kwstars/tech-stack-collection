#!/bin/bash

set -e

cd "$(dirname "$0")"

DOCKER_COMPOSE=$(command -v docker-compose 2>/dev/null || echo "docker compose")

$DOCKER_COMPOSE rm -sfv
