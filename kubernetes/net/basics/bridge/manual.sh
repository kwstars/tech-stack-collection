#!/bin/bash
set -v

# 创建两个网络命名空间 ns1 和 ns2
ip netns add ns1
ip netns add ns2

# 创建一个名为 br0 的网桥，并启动它
ip link add br0 type bridge
ip link set br0 up

# 创建两个 veth 对 int0/br-int0 和 int1/br-int1
ip link add int0 type veth peer name br-int0
ip link add int1 type veth peer name br-int1

# 将 int0 移动到 ns1，并在 ns1 中启动它
ip link set int0 netns ns1
ip netns exec ns1 ip link set int0 up

# 在 ns1 中为 int0 分配 IP 地址 10.1.5.10
ip netns exec ns1 ip addr add 10.1.5.10/24 dev int0

# 将 int1 移动到 ns2，并在 ns2 中启动它
ip link set int1 netns ns2
ip netns exec ns2 ip link set int1 up

# 在 ns2 中为 int1 分配 IP 地址 10.1.5.11
ip netns exec ns2 ip addr add 10.1.5.11/24 dev int1

# 将 br-int0 添加到 br0 网桥，并启动它
ip link set br-int0 master br0
ip link set br-int0 up

# 将 br-int1 添加到 br0 网桥，并启动它
ip link set br-int1 master br0
ip link set br-int1 up
