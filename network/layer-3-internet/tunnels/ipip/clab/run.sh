#!/bin/bash

set -e
set -u

# Switch to the script's directory
cd "$(dirname "$0")"

sudo clab deploy -t ./clab.yaml
docker exec -d clab-ipip-gw1 bash -c 'tcpdump -pen -i eth2 -w /data/gw1-eth2.pcap'
docker exec -d clab-ipip-gw2 bash -c 'tcpdump -pen -i eth2 -w /data/gw2-eth2.pcap'
docker exec -d clab-ipip-server1 bash -c 'curl 10.1.8.10'
docker exec -d clab-ipip-server2 bash -c 'curl 10.1.5.10'
