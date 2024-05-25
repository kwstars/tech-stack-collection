#!/bin/bash
set -e

pgrep tcpdump >/dev/null && sudo pkill tcpdump || echo "No tcpdump process running"

# 检查并删除 brveth0 和 brveth1
sudo ip link show brveth0 &>/dev/null && sudo ip link del brveth0
sudo ip link show brveth1 &>/dev/null && sudo ip link del brveth1

# 检查并删除 br0
sudo ip link show br0 &>/dev/null && sudo ip link del br0

# 检查并删除 ns1 和  ns2
sudo ip netns show | grep -q "ns1" && sudo ip netns del ns1
sudo ip netns show | grep -q "ns2" && sudo ip netns del ns2

echo "Manual bridge cleanup completed"
