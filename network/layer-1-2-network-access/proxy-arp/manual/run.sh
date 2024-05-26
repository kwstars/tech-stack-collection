#/bin/bash

set -e
set -v

# +---------+     +---------+
# |         |     |         |
# |  Host   |     |   ns1   |
# |         |     |         |
# | host_if <-----> ns_if   |
# |         |     |         |
# +---------+     +---------+

# 1. Set up network namespace and its interface
sudo ip netns add ns1
sudo ip link add host_if type veth peer name ns_if
sudo ip link set host_if up
sudo ip link set ns_if netns ns1
sudo ip netns exec ns1 ip link set ns_if up
sudo ip netns exec ns1 ip addr add 1.1.1.2/24 dev ns_if
sudo ip netns exec ns1 ip route add 169.254.1.1 dev ns_if scope link
sudo ip netns exec ns1 ip route add default via 169.254.1.1 dev ns_if

# 2. Enable Proxy ARP and test connectivity to gateway
# In some cases, a device may want to communicate with another device that is not in the same subnet,
# but it does not know how to reach that device. In this case, if a device has Proxy ARP enabled,
# it can respond to ARP requests on behalf of the device that is not in the same subnet. In this way,
# the device sending the ARP request can send the packet to the Proxy ARP device, which will then forward the packet to the correct destination.
echo 1 | sudo tee /proc/sys/net/ipv4/conf/host_if/proxy_arp >/dev/null
sudo ip netns exec ns1 arping 169.254.1.1 -i ns_if

# 3. Add route on host and test connectivity to local network
sudo ip route add 1.1.1.0/24 dev host_if scope link
sudo ip netns exec ns1 arping 192.168.2.66 -i ns_if

# 4. Enable NAT and test connectivity to external network
sudo iptables -t nat -A POSTROUTING -s 1.1.0.0/16 -j MASQUERADE
sudo ip netns exec ns1 arping 114.114.114.114 -i ns_if
