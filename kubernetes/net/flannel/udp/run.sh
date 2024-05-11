#!/bin/bash
set -o errexit
set -o verbose
set -o nounset

# Switch to the script's directory
cd "$(dirname "$0")"

# 1.prep noCNI env
kind create cluster --name=flannel-udp --image=mykindest/node:v1.28.7 --config=./kind.yaml

# 2.remove taints
kubectl taint nodes $(kubectl get nodes --no-headers -o custom-columns=NAME:.metadata.name | grep control-plane) node-role.kubernetes.io/control-plane:NoSchedule-
kubectl get nodes -o wide

# 3.install CNI
# https://github.com/flannel-io/flannel/releases/download/v0.24.4/kube-flannel.yml
kubectl apply -f ./flannel.yaml

# 4. Run a test pod
kubectl apply -f ./test-pod.yaml

kubectl wait --timeout=100s --for=condition=Ready=true pods --all -A

# Captrue packet
docker exec -d flannel-udp-control-plane bash -c "tcpdump -pen -i eth0 -w /data/control-eth0.pcap"
