#!/bin/bash
set -o errexit
set -o verbose
set -o nounset

# Switch to the script's directory
cd "$(dirname "$0")"

# 1.prep noCNI env
kind create cluster --name=flannel-vxlan-directrouting --image=mykindest/node:v1.28.7 --config=./kind.yaml

# 2.remove taints
kubectl taint nodes $(kubectl get nodes --no-headers -o custom-columns=NAME:.metadata.name | grep control-plane) node-role.kubernetes.io/control-plane:NoSchedule-
kubectl get nodes -o wide

# 3. Run clab
sudo ip link add name br-pool0 type bridge
sudo ip link set br-pool0 up

sudo ip link add name br-pool1 type bridge
sudo ip link set br-pool1 up

sudo clab deploy -t clab.yaml

# Install CNI
# https://github.com/flannel-io/flannel/releases/download/v0.25.1/kube-flannel.yml
kubectl apply -f ./flannel.yaml

# Run a test pod
kubectl apply -f ./test-pod.yaml

# Captrue packets
docker exec -d flannel-vxlan-directrouting-control-plane bash -c "tcpdump -pen -i net0 -w /data/control-net0.pcap"
docker exec -d clab-flannel-vxlan-directrouting-gw0 bash -c "tcpdump -pen -i eth1 -w /data/gw0-eth1.pcap"
