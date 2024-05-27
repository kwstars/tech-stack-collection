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

# Install CNI
# helm search repo flannel/flannel --versions
# helm show values flannel/flannel --version 0.25.2
# https://github.com/flannel-io/flannel/tree/master/chart/kube-flannel
helm repo add flannel https://flannel-io.github.io/flannel >/dev/null 2>&1 || true
kubectl create ns kube-flannel >/dev/null 2>&1 || true
kubectl label --overwrite ns kube-flannel pod-security.kubernetes.io/enforce=privileged
helm upgrade --install flannel flannel/flannel --namespace kube-flannel --version 0.25.2 -f flannel-values.yaml

# Captrue packet
docker exec -d "${KIND_NAME}"-control-plane bash -c 'tcpdump -pen -i eth0 -w /data/control-plane-eth0.pcap'
docker exec -d "${KIND_NAME}"-worker bash -c 'tcpdump -pen -i eth0 -w /data/worker1-eth0.pcap'
docker exec -d "${KIND_NAME}"-worker2 bash -c 'tcpdump -pen -i eth0 -w /data/worker2-eth0.pcap'
