#!/bin/bash
set -e
set -v
set -u

readonly KIND_NAME="$1"

# Switch to the script's directory
cd "$(dirname "$0")"

# Create network
docker network rm kind || true
docker network create --subnet=172.30.0.0/16 kind

# Prepare noCNI env
kind create cluster --name="$KIND_NAME" --image=mykindest/node:v1.28.7 --config=./kind.yaml

# Remove taints
controller_node=$(kubectl get nodes --no-headers -o custom-columns=NAME:.metadata.name | grep control-plane)
# controller_node_ip=$(kubectl get node "$controller_node" -o jsonpath='{.status.addresses[?(@.type=="InternalIP")].address}')
kubectl taint nodes "$controller_node" node-role.kubernetes.io/control-plane:NoSchedule-

# 3. Run clab
sudo ip link add name br-pool0 type bridge
sudo ip link set br-pool0 up

sudo ip link add name br-pool1 type bridge
sudo ip link set br-pool1 up

sudo clab deploy -t clab.yaml

# Install CNI
# https://github.com/flannel-io/flannel/releases/download/v0.25.1/kube-flannel.yml
kubectl apply -f ./flannel.yaml

# Captrue packets
# docker exec -d flannel-vxlan-directrouting-control-plane bash -c "tcpdump -pen -i net0 -w /data/control-net0.pcap"
# docker exec -d clab-flannel-vxlan-directrouting-gw0 bash -c "tcpdump -pen -i eth1 -w /data/gw0-eth1.pcap"

docker exec -d clab-"${KIND_NAME}"-gw0 bash -c "tcpdump -pen -i eth1 -w /data/gw0-eth1.pcap"
# docker exec -d clab-"${KIND_NAME}"-server1 bash -c "tcpdump -pen -i net0 -w /data/server1-net0.pcap"
docker exec -d clab-"${KIND_NAME}"-server2 bash -c "tcpdump -pen -i net0 -w /data/server2-net0.pcap"
# docker exec -d clab-"${KIND_NAME}"-server3 bash -c "tcpdump -pen -i net0 -w /data/server3-net0.pcap"
docker exec -d clab-"${KIND_NAME}"-server4 bash -c "tcpdump -pen -i net0 -w /data/server4-net0.pcap"

docker exec -it vxlan-direct-routing-control-plane curl http://10.1.5.11
docker exec -it vxlan-direct-routing-control-plane curl http://10.1.8.11
# docker exec -d "${KIND_NAME}"-control-plane bash -c "tcpdump -pen -i net0 -w /data/control-net0.pcap"
# docker exec -d "${KIND_NAME}"-worker bash -c "tcpdump -pen -i net0 -w /data/worker1-net0.pcap"
# docker exec -d clab-"${KIND_NAME}"-gw0 bash -c "tcpdump -pen -i eth1 -w /data/gw0-eth1.pcap"
