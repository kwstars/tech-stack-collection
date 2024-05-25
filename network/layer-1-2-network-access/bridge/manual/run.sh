#!/bin/bash
set -e

# 创建两个网络命名空间 ns1 和 ns2
sudo ip netns add ns1
sudo ip netns add ns2

# 创建一个名为 br0 的网桥，并启动它
sudo ip link add br0 type bridge
sudo ip link set br0 up

# 创建两个 veth 对 veth0/brveth0 和 veth1/brveth1
sudo ip link add veth0 type veth peer name brveth0
sudo ip link add veth1 type veth peer name brveth1

# 将 veth0 移动到 ns1，并在 ns1 中启动它
sudo ip link set veth0 netns ns1
sudo ip netns exec ns1 ip link set veth0 up

# 在 ns1 中为 veth0 分配 IP 地址 10.1.5.10
sudo ip netns exec ns1 ip addr add 10.1.5.10/24 dev veth0

# 将 veth1 移动到 ns2，并在 ns2 中启动它
sudo ip link set veth1 netns ns2
sudo ip netns exec ns2 ip link set veth1 up

# 在 ns2 中为 veth1 分配 IP 地址 10.1.5.11
sudo ip netns exec ns2 ip addr add 10.1.5.11/24 dev veth1

# 将 brveth0 添加到 br0 网桥，并启动它
sudo ip link set brveth0 master br0
sudo ip link set brveth0 up

# 将 brveth1 添加到 br0 网桥，并启动它
sudo ip link set brveth1 master br0
sudo ip link set brveth1 up

# 捕获接口的报文
sudo nohup tcpdump -pen -i br0 icmp -w manual/br0.pcap >/dev/null 2>&1 &
sudo nohup tcpdump -pen -i brveth0 icmp -w manual/brveth0.pcap >/dev/null 2>&1 &
sudo nohup tcpdump -pen -i brveth1 icmp -w manual/brveth1.pcap >/dev/null 2>&1 &

# echo "sleep for 2 seconds" && sleep 5

# echo "ping"
# sudo ip netns exec ns1 ping -c 2 10.1.5.11
# sudo ip netns exec ns2 ping -c 2 10.1.5.10
