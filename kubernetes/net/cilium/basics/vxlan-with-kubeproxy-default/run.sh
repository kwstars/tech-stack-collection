#!/bin/bash

set -e
set -v

readonly KIND_NAME="$1"

# Switch to the script's directory
cd "$(dirname "$0")"

# Prepare noCNI env
kind create cluster --name="$KIND_NAME" --image=mykindest/node:v1.28.7 --config=./kind.yaml

# Remove taints
controller_node=$(kubectl get nodes --no-headers -o custom-columns=NAME:.metadata.name | grep control-plane)
controller_node_ip=$(kubectl get node "$controller_node" -o jsonpath='{.status.addresses[?(@.type=="InternalIP")].address}')
kubectl taint nodes "$controller_node" node-role.kubernetes.io/control-plane:NoSchedule-

# Fix https://github.com/cilium/cilium/issues/23838
sudo chown -R root:root /opt/cni/bin

# Load images
# kind load docker-image quay.io/cilium/operator-generic:v1.15.5 --name=$KIND_NAME

# Install CNI
# helm search repo cilium/cilium --versions
# helm show values cilium/cilium
# https://github.com/cilium/charts
helm repo add cilium https://helm.cilium.io >/dev/null 2>&1
helm upgrade --install cilium cilium/cilium --namespace kube-system --create-namespace --version 1.15.5 -f cilium-values.yaml \
  --set k8sServiceHost="$controller_node_ip" \
  --set k8sServicePort=6443

# Install necessary tools
# for i in $(docker ps -a --format "table {{.Names}}" | grep cilium); do
#   echo $i
#   docker cp /usr/local/bin/cilium $i:/usr/local/bin/cilium
#   docker cp /usr/bin/ping $i:/usr/bin/ping
# done

# Run a test pod
# kubectl apply -f ./test-pod.yaml
# kubectl wait --timeout=100s --for=condition=Ready=true pods --all -A

# Capture packet
docker exec -d "${KIND_NAME}"-control-plane bash -c 'tcpdump -pen -i eth0 -w /data/control-plane-eth0.pcap'
docker exec -d "${KIND_NAME}"-worker bash -c 'tcpdump -pen -i eth0 -w /data/worker1-eth0.pcap'
docker exec -d "${KIND_NAME}"-worker2 bash -c 'tcpdump -pen -i eth0 -w /data/worker2-eth0.pcap'
