#!/bin/bash

# Delete the veth endpoints if they exist
sudo ip netns exec ns1 ip link delete veth-10 2>/dev/null || true
sudo ip netns exec ns2 ip link delete veth-20 2>/dev/null || true

# Delete the network namespaces if they exist
sudo ip netns delete ns1 2>/dev/null || true
sudo ip netns delete ns2 2>/dev/null || true
