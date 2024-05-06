#!/bin/bash

# BPF71
# 创建了一个名为 ns1 的网络命名空间和一个名为 br0 的桥接设备。
ip netns add ns1
ip link add br0 type bridge
ip link set br0 up
# 创建了一个名为 int0 的 veth 设备和它的对端 br-int0，并将 int0 移动到 ns1 命名空间
ip link add int0 type veth peer name br-int0
ip link set int0 netns ns1
ip netns exec ns1 ip link set int0 up
# 分配 IP 地址 10.1.5.10/24，并设置了默认路由 10.1.5.1
ip netns exec ns1 ip addr add 10.1.5.10/24 dev int0
ip netns exec ns1 ip route add default via 10.1.5.1
# 将 br-int0 添加到 br0 桥接设备，并启动 br-int0
ip link set br-int0 master br0
ip link set br-int0 up
# 给 br0 分配了 IP 地址 10.1.5.1/24，并添加了一个路由 10.1.8.0/24，通过 ens160 设备和网关 192.168.2.73
ip addr add 10.1.5.1/24 dev br0
ip route add 10.1.8.0/24 via 192.168.2.73 dev ens160

# BPF73
ip netns add ns1
ip link add br0 type bridge
ip link set br0 up
ip link add int0 type veth peer name br-int0
ip link set int0 netns ns1
ip netns exec ns1 ip link set int0 up
ip netns exec ns1 ip addr add 10.1.8.10/24 dev int0
ip netns exec ns1 ip route add default via 10.1.8.1
ip link set br-int0 master br0
ip link set br-int0 up
ip addr add 10.1.8.1/24 dev br0
ip route add 10.1.5.0/24 via 192.168.2.71 dev ens160
