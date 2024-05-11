#/bin/bash

set -e
set -v

# +---------+     +---------+
# |         |     |         |
# |  Host   |     |   ns1   |
# |         |     |         |
# |  veth   <-----> c-eth0  |
# |         |     |         |
# +---------+     +---------+

# 1. Prepare the ns1 configuration
sudo ip netns add ns1
sudo ip link add veth type veth peer name c-eth0
sudo ip link set veth up
sudo ip link set c-eth0 netns ns1
sudo ip netns exec ns1 ip link set c-eth0 up
sudo ip netns exec ns1 ip addr add 1.1.1.2/24 dev c-eth0
sudo ip netns exec ns1 ip route add 169.254.1.1 dev c-eth0 scope link
sudo ip netns exec ns1 ip route add default via 169.254.1.1 dev c-eth0

# 2. Test availability to gw [with Proxy ARP enabled]
# In some cases, a device may want to communicate with another device that is not in the same subnet,
# but it does not know how to reach that device. In this case, if a device has Proxy ARP enabled,
# it can respond to ARP requests on behalf of the device that is not in the same subnet. In this way,
# the device sending the ARP request can send the packet to the Proxy ARP device, which will then forward the packet to the correct destination.
echo 1 | sudo tee /proc/sys/net/ipv4/conf/veth/proxy_arp >/dev/null # sudo sysctl -w net.ipv4.conf.veth.proxy_arp=1
sudo ip netns exec ns1 arping 169.254.1.1 -i c-eth0

# 3. Add a fallback route on the host [route-n tells the host how to forward the packet to ns1]
sudo ip route add 1.1.1.0/24 dev veth scope link
sudo ip netns exec ns1 arping 192.168.2.66 -i c-eth0

# 4. Test to external network [114.114.114.114]
sudo iptables -t nat -A POSTROUTING -s 1.1.0.0/16 -j MASQUERADE
suod ip netns exec ns1 arping 114.114.114.114 -i c-eth0
