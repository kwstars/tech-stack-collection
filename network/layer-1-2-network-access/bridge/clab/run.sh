#!/bin/bash

set -e
set -u

# Switch to the script's directory
cd "$(dirname "$0")"

if ! ip link show br0 >/dev/null 2>&1; then
  sudo ip link add name br0 type bridge
  sudo ip link set br0 up
fi

sudo clab deploy -t ./clab.yaml

# 显示所有类型为 bridge 的网络接口
# ip link show type bridge

# 显示 eth1 设备的 bridge 链接信息
# bridge link show dev eth1

# 在名为 clab-bridge-server1 的 Docker 容器中，显示 eth1 网络接口的信息
# docker exec -it clab-bridge-server1 ip link show eth1

# 显示 br0 bridge 的 MAC 地址表
# brctl showmacs br0

docker exec -d clab-bridge-server1 bash -c 'tcpdump -pen -i eth1 -w /data/server1-eth1.pcap'
docker exec -d clab-bridge-server2 bash -c 'tcpdump -pen -i eth1 -w /data/server2-eth1.pcap'
docker exec -d clab-bridge-server1 bash -c 'curl 10.0.0.12'
docker exec -d clab-bridge-server2 bash -c 'curl 10.0.0.11'
