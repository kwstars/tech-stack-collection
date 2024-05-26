#!/bin/bash
set -e

# Switch to the script's directory
cd "$(dirname "$0")"

# Check if wireguard-tools is installed, if not, install it
if ! dpkg -l | grep -q wireguard-tools; then
  sudo apt update && sudo apt install wireguard-tools -y
fi

# Generate private and public keys if they do not exist
generate_keys() {
  local key_name=$1
  if [ ! -f "${key_name}_private" ]; then
    wg genkey >"${key_name}_private"
    wg pubkey <"${key_name}_private" >"${key_name}_public"
  fi
  cat "${key_name}_public"
}

GW1_PUBLIC=$(generate_keys "gw1")
GW2_PUBLIC=$(generate_keys "gw2")

# Build Image
docker build -t my-wireguard .

[ -f "./clab.yaml" ] || cat <<EOF >./clab.yaml
# server1 (10.1.5.10/24) <--> (eth1:10.1.5.1/24) gw1 (eth2:172.12.1.10/24) <--> (eth2:172.12.1.11/24) gw2 (eth1:10.1.8.1/24) <--> server2 (10.1.8.10/24)
name: wireguard
topology:
  defaults:
    sysctls:
      net.ipv4.ip_forward: 1
  nodes:
    gw1:
      kind: linux
      image: my-wireguard
      exec:
        - ip addr add 10.1.5.1/24 dev eth1
        - ip addr add 172.12.1.10/24 dev eth2
        - ip link add wg0 type wireguard
        - ip address add 20.0.0.1/24 dev wg0
        - wg set wg0 private-key /data/gw1_private
        - ip link set wg0 up
        - wg set wg0 listen-port 51820
        - wg set wg0 peer $GW2_PUBLIC allowed-ips 0.0.0.0/0,::/0 endpoint 172.12.1.11:51820
        - ip route add 10.1.8.0/24 via 20.0.0.2
      binds:
        - .:/data
    gw2:
      kind: linux
      image: my-wireguard
      exec:
        - ip addr add 10.1.8.1/24 dev eth1
        - ip addr add 172.12.1.11/24 dev eth2
        - ip link add wg0 type wireguard
        - ip address add 20.0.0.2/24 dev wg0
        - wg set wg0 private-key /data/gw2_private
        - ip link set wg0 up
        - wg set wg0 listen-port 51820
        - wg set wg0 peer $GW1_PUBLIC allowed-ips 0.0.0.0/0,::/0 endpoint 172.12.1.10:51820
        - ip route add 10.1.5.0/24 via 20.0.0.1
      binds:
        - .:/data
    server1:
      kind: linux
      image: wbitt/network-multitool
      exec:
        - ip addr add 10.1.5.10/24 dev net0
        - ip route replace default via 10.1.5.1
      binds:
        - .:/data
    server2:
      kind: linux
      image: wbitt/network-multitool
      exec:
        - ip addr add 10.1.8.10/24 dev net0
        - ip route replace default via 10.1.8.1
      binds:
        - .:/data
  links:
    - endpoints: ["gw1:eth1", "server1:net0"]
    - endpoints: ["gw2:eth1", "server2:net0"]
    - endpoints: ["gw1:eth2", "gw2:eth2"]
EOF

sudo clab deploy -t ./clab.yaml

docker exec -d clab-wireguard-gw1 bash -c 'tcpdump -pen -i eth2 -w /data/gw1-eth2.pcap'
docker exec -d clab-wireguard-gw2 bash -c 'tcpdump -pen -i eth2 -w /data/gw2-eth2.pcap'
docker exec -d clab-wireguard-server1 bash -c 'curl 10.1.8.10'
docker exec -d clab-wireguard-server2 bash -c 'curl 10.1.5.10'
