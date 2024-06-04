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

# 大多数现代浏览器（包括 Chrome）不支持 h2c，因为他们默认使用加密的 HTTP/2（h2）。这是因为浏览器厂商希望推动全网的加密，因此他们决定只支持加密的 HTTP/2。
# --http2-prior-knowledge 选项，它告诉 curl 只使用 HTTP/2 协议进行请求，而不进行协议协商或回退到 HTTP/1.1。这个选项应该只在你知道服务器肯定支持 HTTP/2 的情况下使用。
curl -v --http2-prior-knowledge http://localhost:8080
