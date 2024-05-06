#!/bin/bash
set -v
# +--------+     +--------+
# |        |     |        |
# |  ns1   |     |  ns2   |
# |        |     |        |
# | veth-01|-----|veth-10 |
# |10.1.5.10|    |10.1.5.11|
# +--------+     +--------+

# Create network namespaces
ip netns add ns1
ip netns add ns2

# Create a veth pair
ip link add veth-01 type veth peer name veth-10

# Assign the veth endpoints to the namespaces
ip link set veth-01 netns ns1
ip link set veth-10 netns ns2

# Bring up the veth endpoints
ip netns exec ns1 ip link set veth-01 up
ip netns exec ns2 ip link set veth-10 up

# Assign IP addresses to the veth endpoints
ip netns exec ns1 ip addr add 10.1.5.10/24 dev veth-01
ip netns exec ns2 ip addr add 10.1.5.11/24 dev veth-10
