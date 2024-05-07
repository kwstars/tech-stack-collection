#!/bin/bash

ip netns add ns1
ip link add br0 type bridge
ip link set br0 up
ip link add int0 type veth peer name br-int0
ip link set int0 netns ns1
ip netns exec ns1 ip link set int0 up
ip netns exec ns1 ip addr add 10.1.5.10/24 dev int0
ip netns exec ns1 ip route add default via 10.1.5.1
ip link set br-int0 master br0
ip link set br-int0 up
ip addr add 10.1.5.1/24 dev br0
ip route add 10.1.8.0/24 via 192.168.2.73 dev ens160
