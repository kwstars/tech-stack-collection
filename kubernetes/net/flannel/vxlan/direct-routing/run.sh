#!/bin/bash
set -e
set -v
set -u

readonly KIND_NAME="$1"

# Switch to the script's directory
cd "$(dirname "$0")"

# Prepare noCNI env
# kind create cluster --name="$KIND_NAME" --image=mykindest/node:v1.28.7 --config=./kind.yaml

# Run clab
sudo ip link add name br-pool0 type bridge
sudo ip link set br-pool0 up

sudo ip link add name br-pool1 type bridge
sudo ip link set br-pool1 up

# https://github.com/srl-labs/containerlab/issues/669
sudo -E clab deploy -t clab.yaml
sudo chown -R "$USER":"$USER" /home/"$USER"/.kube/
# sudo clab graph  -t vxlan/direct-routing/clab.yaml

# Remove taints
controller_node=$(kubectl get nodes --no-headers -o custom-columns=NAME:.metadata.name | grep control-plane)
# controller_node_ip=$(kubectl get node "$controller_node" -o jsonpath='{.status.addresses[?(@.type=="InternalIP")].address}')
kubectl taint nodes "$controller_node" node-role.kubernetes.io/control-plane:NoSchedule-

# Install CNI
# https://github.com/flannel-io/flannel/releases/download/v0.25.1/kube-flannel.yml
kubectl apply -f ./flannel.yaml

# Captrue packets
docker exec -it k01-control-plane bash -c "apt-get update && apt-get install -y tcpdump"
docker exec -it k01-worker bash -c "apt-get update && apt-get install -y tcpdump"
docker exec -it k01-worker3 bash -c "apt-get update && apt-get install -y tcpdump"
docker exec -d clab-vxlan-direct-routing-gw0 bash -c "tcpdump -pen -i eth1 -w /data/gw0-eth1.pcap"
docker exec -d k01-control-plane bash -c "tcpdump -pen -i net0 -w /data/control-net0.pcap"
docker exec -d k01-worker bash -c "tcpdump -pen -i net0 -w /data/worker1-net0.pcap"
docker exec -d k01-worker3 bash -c "tcpdump -pen -i net0 -w /data/worker3-net0.pcap"

# 进入 k01-control-plane 上的 Pod 发送请求到 k01-worker 和 k01-worker3 上 Pod
