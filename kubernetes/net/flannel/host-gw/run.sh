#!/bin/bash
set -e
set -v
set -u

readonly LAB_NAME="$1"

# Switch to the script's directory
cd "$(dirname "$0")"

# Create network
docker network rm kind || true
docker network create --subnet=172.30.0.0/16 kind

# Prepare noCNI env
kind create cluster --name="$LAB_NAME" --image=mykindest/node:v1.28.7 --config=./kind.yaml

# Remove taints
controller_node=$(kubectl get nodes --no-headers -o custom-columns=NAME:.metadata.name | grep control-plane)
# controller_node_ip=$(kubectl get node "$controller_node" -o jsonpath='{.status.addresses[?(@.type=="InternalIP")].address}')
kubectl taint nodes "$controller_node" node-role.kubernetes.io/control-plane:NoSchedule-

# Install CNI

# https://github.com/flannel-io/flannel/releases/download/v0.25.1/kube-flannel.yml
kubectl apply -f ./flannel.yaml

# Captrue packet
docker exec -d "${LAB_NAME}"-control-plane bash -c 'tcpdump -pen -i eth0 -w /data/control-plane-eth0.pcap'
docker exec -d "${LAB_NAME}"-worker bash -c 'tcpdump -pen -i eth0 -w /data/worker1-eth0.pcap'
docker exec -d "${LAB_NAME}"-worker2 bash -c 'tcpdump -pen -i eth0 -w /data/worker2-eth0.pcap'
