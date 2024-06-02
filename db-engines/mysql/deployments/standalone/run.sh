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
