#!/bin/bash

set -e
set -v
set -u
set -x

readonly LAB_NAME=$1

VERSION=v0.13.0

cd "$(dirname "$0")"

function pull_and_load_images() {
  local IMAGES=(
    "grafana/grafana:9.5.3"
    "jimmidyson/configmap-reload:v0.5.0"
    "quay.io/brancz/kube-rbac-proxy:v0.14.2"
    "quay.io/prometheus-operator/prometheus-operator:v0.67.1"
    "quay.io/prometheus/blackbox-exporter:v0.24.0"
    "quay.io/prometheus/node-exporter:v1.6.1"
    "quay.io/prometheus/alertmanager:v0.26.0"
    "quay.io/prometheus-operator/prometheus-config-reloader:v0.67.1"
    "quay.io/prometheus/prometheus:v2.46.0"
  )

  for IMAGE in "${IMAGES[@]}"; do
    docker pull "$IMAGE"
    kind load docker-image "$IMAGE" --name "$LAB_NAME"
  done
}

function pull_and_retag_images() {
  local SOURCE_REGISTRY=$1
  local TARGET_REGISTRY=$2
  local IMAGES=(
    "kube-state-metrics/kube-state-metrics:v2.9.2"
    "prometheus-adapter/prometheus-adapter:v0.11.1"
    "ingress-nginx/kube-webhook-certgen:v1.4.1"
    "ingress-nginx/controller:v1.10.1"
  )

  for IMAGE in "${IMAGES[@]}"; do
    TARGET_IMAGE="$TARGET_REGISTRY"/"$IMAGE"
    echo "Pulling $TARGET_IMAGE"
    if ! docker image inspect "$TARGET_IMAGE" >/dev/null 2>&1; then
      docker pull "$SOURCE_REGISTRY"/"$IMAGE"
      docker tag "$SOURCE_REGISTRY"/"$IMAGE" "$TARGET_IMAGE"
      docker rmi "$SOURCE_REGISTRY"/"$IMAGE"
    fi
    kind load docker-image "$TARGET_IMAGE" --name "$LAB_NAME"
  done
}

# Create K8S
kind create cluster --name "$LAB_NAME" --config kind.yaml

pull_and_load_images
pull_and_retag_images "k8s.dockerproxy.com" "registry.k8s.io"

controller_node=$(kubectl get nodes --no-headers -o custom-columns=NAME:.metadata.name | grep control-plane)
# controller_node_ip=$(kubectl get node "$controller_node" -o jsonpath='{.status.addresses[?(@.type=="InternalIP")].address}')
kubectl taint nodes "$controller_node" node-role.kubernetes.io/control-plane:NoSchedule-

# Download kube-prometheus
if [ ! -d kube-prometheus ]; then git clone https://github.com/prometheus-operator/kube-prometheus.git; fi
cd kube-prometheus && git checkout "$VERSION" && cd ..

# Install kube-prometheus CRDs
# https://github.com/prometheus-operator/prometheus-operator/issues/5104
kubectl apply --server-side -f kube-prometheus/manifests/setup
kubectl get crds | grep coreos

# Install kube-prometheus
kubectl apply -f kube-prometheus/manifests/

# Patch kube-prometheus
# kubectl patch prometheus k8s -n monitoring --type='json' -p='[{"op": "replace", "path": "/spec/replicas", "value":1}]'
# kubectl patch alertmanager main -n monitoring --type='json' -p='[{"op": "replace", "path": "/spec/replicas", "value":1}]'
# kubectl patch svc alertmanager-main -n monitoring -p '{"spec": {"type": "NodePort"}}'
# kubectl patch svc grafana -n monitoring -p '{"spec": {"type": "NodePort"}}'
# kubectl patch svc prometheus-k8s -n monitoring -p '{"spec": {"type": "NodePort"}}'

# ingress-nginx https://kind.sigs.k8s.io/docs/user/ingress#ingress-nginx
# kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/kind/deploy.yaml
kubectl apply -f manifests/ingress-nginx.yaml
kubectl wait --for=condition=ready pod -l app.kubernetes.io/component=controller -n ingress-nginx
kubectl apply -f manifests/prometheus-ingress.yaml

# Fix warnings
