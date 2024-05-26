#!/bin/bash

set -e
set -u

# Switch to the script's directory
cd "$(dirname "$0")"

sudo clab deploy -t ./clab.yaml
docker exec -d clab-veth-server1 bash -c 'tcpdump -pen -i net0 -w /data/server1-net0.pcap'
docker exec -d clab-veth-server2 bash -c 'tcpdump -pen -i net0 -w /data/server2-net0.pcap'
docker exec -d clab-veth-server1 bash -c 'curl 10.1.8.10'
docker exec -d clab-veth-server2 bash -c 'curl 10.1.5.10'
