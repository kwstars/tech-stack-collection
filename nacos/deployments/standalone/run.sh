#!/bin/bash

# https://github.com/nacos-group/nacos-docker/blob/master/README.md

# 启用严格模式：
# -e: 脚本在命令失败时退出
# -u: 使用未定义变量时退出
# -x: 打印每个命令在执行前
# -o pipefail: 管道中任何命令失败时整个管道失败
set -euxo pipefail

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

if [ ! -d "nacos-docker" ]; then
  git clone --depth 1 https://github.com/nacos-group/nacos-docker.git
else
  echo "nacos-docker repository already cloned."
fi

cd nacos-docker

if ! docker-compose -f example/standalone-derby.yaml ps | grep -q 'Up'; then
  docker-compose -f example/standalone-derby.yaml up -d
else
  echo "Docker Compose is already running."
fi
