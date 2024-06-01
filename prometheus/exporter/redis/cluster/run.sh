#!/bin/bash

set -euo pipefail

echo "Please enter the IP of the physical machine:"
read -r machine_ip
echo "The IP you entered is: $machine_ip"

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

# Change prometheus.yml to use the IP of the physical machine
cat <<EOF >./startup-config/prometheus.yml
# https://prometheus.io/docs/prometheus/latest/configuration/configuration/
# https://github.com/prometheus/prometheus/blob/main/documentation/examples/prometheus.yml

global:
  scrape_interval: 15s
  evaluation_interval: 15s

scrape_configs:
  - job_name: "prometheus"
    static_configs:
      - targets: ["localhost:9090"]
  # https://github.com/oliver006/redis_exporter
  # https://github.com/oliver006/redis_exporter/issues/281
  - job_name: "redis_exporter_targets"
    static_configs:
      - targets:
          - redis://$machine_ip:7000
          - redis://$machine_ip:7001
          - redis://$machine_ip:7002
          - redis://$machine_ip:7003
          - redis://$machine_ip:7004
          - redis://$machine_ip:7005
    metrics_path: /scrape
    relabel_configs:
        # 将每个 Redis 实例的地址（即 __address__）复制到查询参数 target（即 __param_target）。这样，当 Prometheus 向 Redis exporter 发送 HTTP 请求时，请求的 URL 中就会包含一个 target 查询参数，其值就是 Redis 实例的地址。
      - source_labels: [__address__]
        target_label: __param_target
        # 将查询参数 target 的值复制到 instance 标签。这样，每个抓取到的指标都会带有一个 instance 标签，其值就是对应的 Redis 实例的地址。这对于后续的数据分析和故障排查非常有用，因为你可以根据 instance 标签来过滤或者聚合指标。
      - source_labels: [__param_target]
        target_label: instance
        # 将每个 Redis 实例的地址（即 __address__）替换为 Redis exporter 的地址。这样，Prometheus 实际上是向 Redis exporter 发送 HTTP 请求，而不是直接向 Redis 实例发送请求。这是因为 Prometheus 不能直接抓取 Redis 的指标，需要通过 Redis exporter 来转换。
      - target_label: __address__
        replacement: redis_exporter:9121

  - job_name: "redis_exporter"
    static_configs:
      - targets:
          - redis_exporter:9121
EOF

# Start the Prometheus and Redis exporter
run_docker_compose up -d

sleep 10

# Create the cluster
run_docker_compose exec redis-node-0 redis-cli --cluster create \
  "$machine_ip":7000 \
  "$machine_ip":7001 \
  "$machine_ip":7002 \
  "$machine_ip":7003 \
  "$machine_ip":7004 \
  "$machine_ip":7005 \
  --cluster-replicas 1 --cluster-yes

# Query the 'up' metric from Prometheus. This metric indicates the health of the targets.
# If the target is up and healthy, the value is 1. Otherwise, the value is 0.
curl "http://127.0.0.1:9090/api/v1/query?query=up"

# Benchmark the cluster
sudo apt update
sudo apt -y install redis-tools
redis-benchmark --cluster -h localhost -p 7000 -c 100 -n 100000
