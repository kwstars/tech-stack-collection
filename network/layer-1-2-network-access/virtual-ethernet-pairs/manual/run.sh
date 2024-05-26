#!/bin/bash
set -v
# +---------+     +---------+
# |         |     |         |
# |  ns1    |     |  ns2    |
# |         |     |         |
# | veth-10 |-----| veth-20 |
# |10.1.5.10|     |10.1.5.11|
# +---------+     +---------+

# Create network namespaces
sudo ip netns add ns1
sudo ip netns add ns2

# Create a veth pair
sudo ip link add veth-10 type veth peer name veth-20

# Assign the veth endpoints to the namespaces
sudo ip link set veth-10 netns ns1
sudo ip link set veth-20 netns ns2

# Bring up the veth endpoints
sudo ip netns exec ns1 ip link set veth-10 up
sudo ip netns exec ns2 ip link set veth-20 up

# Assign IP addresses to the veth endpoints
sudo ip netns exec ns1 ip addr add 10.1.5.10/24 dev veth-10
sudo ip netns exec ns2 ip addr add 10.1.5.11/24 dev veth-20

# Test the connectivity
sudo ip netns exec ns1 ping -c 2 10.1.5.11
sudo ip netns exec ns2 ping -c 2 10.1.5.10

# Show the veth endpoints
sudo ip netns exec ns1 ip link show veth-10
sudo ip netns exec ns2 ip link show veth-20

# Show the veth endpoints using type
sudo ip netns exec ns1 ip link show type veth
sudo ip netns exec ns2 ip link show type veth
