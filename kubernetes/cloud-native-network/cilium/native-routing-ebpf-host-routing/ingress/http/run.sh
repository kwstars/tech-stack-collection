#!/bin/bash

set -e
set -v

readonly LAB_NAME="$1"

# Switch to the script's directory
cd "$(dirname "$0")"

function pull_and_load_images() {
  # local NAME=$1
  local IMAGES=(
    # metallb
    "quay.io/metallb/controller:v0.14.5"
    "quay.io/metallb/speaker:v0.14.5"
    "quay.io/frrouting/frr:9.0.2"
    # bookinfo application
    "docker.io/istio/examples-bookinfo-details-v1:1.16.2"
    "docker.io/istio/examples-bookinfo-ratings-v1:1.16.2"
    "docker.io/istio/examples-bookinfo-reviews-v1:1.16.2"
    "docker.io/istio/examples-bookinfo-productpage-v1:1.16.2"
  )

  for IMAGE in "${IMAGES[@]}"; do
    docker pull "$IMAGE"
    kind load docker-image "$IMAGE" --name "$LAB_NAME"
  done
}

docker network rm kind || true
docker network create --subnet=172.30.0.0/16 kind

# Prepare noCNI env
kind create cluster --name="$LAB_NAME" --image=mykindest/node:v1.28.7 --config=./kind.yaml

# # Remove taints
controller_node=$(kubectl get nodes --no-headers -o custom-columns=NAME:.metadata.name | grep control-plane)
controller_node_ip=$(kubectl get node "$controller_node" -o jsonpath='{.status.addresses[?(@.type=="InternalIP")].address}')
kubectl taint nodes "$controller_node" node-role.kubernetes.io/control-plane:NoSchedule-

pull_and_load_images

# Fix https://github.com/cilium/cilium/issues/23838
sudo chown -R root:root /opt/cni/bin

# Install MetalLB
helm repo add metallb https://metallb.github.io/metallb >/dev/null 2>&1
helm upgrade --install metallb metallb/metallb --namespace metallb --create-namespace --version 0.14.5

# Install CNI
# helm search repo cilium/cilium --versions
# helm show values cilium/cilium
# https://github.com/cilium/charts
helm repo add cilium https://helm.cilium.io >/dev/null 2>&1
helm upgrade --install cilium cilium/cilium --namespace kube-system --create-namespace --version 1.15.5 -f cilium-values.yaml \
  --set k8sServiceHost="$controller_node_ip" \
  --set k8sServicePort=6443

# Defining The IPs To Assign To The Load Balancer Services
kubectl wait --timeout=100s --for=condition=Ready=true pods --all -A
cat <<EOF | kubectl apply -f -
apiVersion: metallb.io/v1beta1
kind: IPAddressPool
metadata:
  name: ip-pool
  namespace: metallb
spec:
  addresses:
    - 172.30.0.200-172.30.0.210
---
apiVersion: metallb.io/v1beta1
kind: L2Advertisement
metadata:
  name: ip-advertisement
  namespace: metallb
spec:
  ipAddressPools:
    - ip-pool
EOF
