#!/bin/bash
set -o errexit
set -o verbose
set -o nounset

# Switch to the script's directory
cd "$(dirname "$0")"

# Prepare noCNI env
kind create cluster --name=calico-ipip-default --image=mykindest/node:v1.28.7 --config=./kind.yaml

# 2.remove taints
NODES=$(kubectl get nodes --no-headers -o custom-columns=NAME:.metadata.name | grep control-plane)
kubectl taint nodes $NODES node-role.kubernetes.io/control-plane:NoSchedule-

# Install CNI
# kubectl apply -f https://raw.githubusercontent.com/projectcalico/calico/v3.27.3/manifests/calico.yaml
kubectl apply -f ./calico.yaml

# Run a test pod
kubectl apply -f ./test-pod.yaml

kubectl wait --timeout=60s --for=condition=Ready=true pods --all -A
kubectl get nodes -o wide

# Captrue packets
docker exec -d calico-ipip-default-control-plane bash -c "tcpdump -pen -i eth0 -w /data/control-eth0.pcap"
