#!/bin/bash
set -o errexit
set -o verbose
set -o nounset

# Switch to the script's directory
cd "$(dirname "$0")"

# 1.prep noCNI env
kind create cluster --name=calico-ipip-cross-subnet --image=mykindest/node:v1.28.7 --config=./kind.yaml

# 2.remove taints
kubectl taint nodes $(kubectl get nodes --no-headers -o custom-columns=NAME:.metadata.name | grep control-plane) node-role.kubernetes.io/control-plane:NoSchedule-

# 3. Run clab
sudo ip link add name br-pool0 type bridge
sudo ip link set br-pool0 up

sudo ip link add name br-pool1 type bridge
sudo ip link set br-pool1 up

sudo clab deploy -t clab.yaml

# Install CNI
# kubectl apply -f https://raw.githubusercontent.com/projectcalico/calico/v3.27.3/manifests/calico.yaml
kubectl apply -f ./calico.yaml

# Run a test pod
kubectl apply -f ./test-pod.yaml

kubectl wait --timeout=100s --for=condition=Ready=true pods --all -A

# Captrue packets
docker exec -d calico-ipip-cross-subnet-control-plane bash -c "tcpdump -pen -i net0 -w /data/control-net0.pcap"
docker exec -d clab-calico-ipip-cross-subnet-gw0 bash -c "tcpdump -pen -i eth1 -w /data/gw0-eth1.pcap"
