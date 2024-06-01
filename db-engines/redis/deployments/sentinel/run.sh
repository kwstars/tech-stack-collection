#!/bin/bash

set -e
set -v
set -x
set -u

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

script_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
cd "$script_dir"

echo "Please enter the host IP:"
read -r machine_ip

cat <<EOF >docker-compose.yaml
services:
  redis1:
    image: redis:7.0
    network_mode: host
    volumes:
      - "redis1-data:/data:rw"
    command: ["redis-server", "--appendonly", "yes", "--port", "16379"]
    healthcheck:
      test: ["CMD", "redis-cli", "-p", "16379", "ping"]
      interval: 5s
      timeout: 3s
      retries: 3
      start_period: 10s

  redis2:
    depends_on:
      redis1:
        condition: service_healthy
    image: redis:7.0
    network_mode: host
    volumes:
      - "redis2-data:/data:rw"
    command:
      [
        "redis-server",
        "--appendonly",
        "yes",
        "--port",
        "26379",
        "--slaveof",
        "$machine_ip",
        "16379",
      ]
    healthcheck:
      test: ["CMD", "redis-cli", "-p", "26379", "ping"]
      interval: 5s
      timeout: 3s
      retries: 3
      start_period: 10s

  redis3:
    depends_on:
      redis1:
        condition: service_healthy
    image: redis:7.0
    network_mode: host
    volumes:
      - "redis3-data:/data:rw"
    command:
      [
        "redis-server",
        "--appendonly",
        "yes",
        "--port",
        "36379",
        "--slaveof",
        "$machine_ip",
        "16379",
      ]
    healthcheck:
      test: ["CMD", "redis-cli", "-p", "36379", "ping"]
      interval: 5s
      timeout: 3s
      retries: 3
      start_period: 10s

  sentinel1:
    depends_on:
      redis1:
        condition: service_healthy
      redis2:
        condition: service_healthy
      redis3:
        condition: service_healthy
    build:
      context: .
    ports:
      - "0.0.0.0:20001:26379"
    command: ["redis-sentinel", "/etc/redis/sentinel.conf"]
    healthcheck:
      test: ["CMD", "redis-cli", "-p", "26379", "ping"]
      interval: 30s
      timeout: 5s
      retries: 3
      start_period: 10s

  sentinel2:
    depends_on:
      redis1:
        condition: service_healthy
      redis2:
        condition: service_healthy
      redis3:
        condition: service_healthy
    build:
      context: .
    ports:
      - "0.0.0.0:20002:26379"
    command: ["redis-sentinel", "/etc/redis/sentinel.conf"]
    healthcheck:
      test: ["CMD", "redis-cli", "-p", "26379", "ping"]
      interval: 30s
      timeout: 5s
      retries: 3
      start_period: 10s

  sentinel3:
    depends_on:
      redis1:
        condition: service_healthy
      redis2:
        condition: service_healthy
      redis3:
        condition: service_healthy
    build:
      context: .
    ports:
      - "0.0.0.0:20003:26379"
    command: ["redis-sentinel", "/etc/redis/sentinel.conf"]
    healthcheck:
      test: ["CMD", "redis-cli", "-p", "26379", "ping"]
      interval: 30s
      timeout: 5s
      retries: 3
      start_period: 10s

volumes:
  redis1-data:
  redis2-data:
  redis3-data:

networks:
  default:
    name: monitoring
EOF

cat <<EOF >sentinel.conf
# https://github.com/redis/redis/blob/7.0/sentinel.conf

# 运行端口
port 26379

sentinel resolve-hostnames yes

# 监控名为 "mymaster" 的 Redis 主服务器，该服务器的地址为 "redis1"，端口为 6379, 且在进行故障转移时，需要至少有 2 个 Sentinel 实例同意。
sentinel monitor mymaster "$machine_ip" 16379 2

# 如果主服务器在 <milliseconds> 毫秒内没有响应任何 Sentinel 的 PING, 那么 Sentinel 就会认为主服务器失效。
sentinel down-after-milliseconds mymaster 30000

# 在故障转移过程中，最多可以有多少个从服务器同时对新的主服务器进行同步。
sentinel parallel-syncs mymaster 1

# 如果在 <timeout> 毫秒内, Sentinel 无法完成故障转移，那么这次故障转移就会被取消。
sentinel failover-timeout mymaster 180000

# 如果 Redis 主服务器需要密码，那么可以使用这个配置指定密码。
# sentinel auth-pass <master-name> <password>

# 这个配置是 Sentinel 内部使用的，用于记录配置的版本。用户通常不需要修改这个配置。
# sentinel config-epoch <master-name> <epoch>
# 这个配置也是 Sentinel 内部使用的，用于记录领导者选举的版本。用户通常也不需要修改这个配置
# sentinel leader-epoch <master-name> <epoch>
EOF

wait_for_services() {
  run_docker_compose up -d

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

run_docker_compose exec redis1 redis-cli -p 16379 INFO REPLICATION
run_docker_compose exec redis2 redis-cli -p 26379 INFO REPLICATION
run_docker_compose exec redis3 redis-cli -p 36379 INFO REPLICATION
run_docker_compose exec sentinel1 redis-cli -p 26379 INFO SENTINEL
run_docker_compose exec sentinel2 redis-cli -p 26379 INFO SENTINEL
run_docker_compose exec sentinel3 redis-cli -p 26379 INFO SENTINEL
