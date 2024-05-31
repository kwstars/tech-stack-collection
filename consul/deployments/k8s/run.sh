#!/bin/bash
# https://developer.hashicorp.com/consul/tutorials/get-started-kubernetes/kubernetes-gs-deploy?variants=consul-deploy%3Aself-managed

set -e
set -u
set -v

cd "$(dirname "$0")"

readonly LAB_NAME="$1"

function pull_and_load_images() {
  local IMAGES=(
    hashicorp/consul-k8s-control-plane:1.4.3
    hashicorp/consul:1.18.2
  )

  for IMAGE in "${IMAGES[@]}"; do
    docker pull "$IMAGE"
    kind load docker-image "$IMAGE" --name "$LAB_NAME"
  done
}

kind create cluster --name "$LAB_NAME" --config=kind.yaml

pull_and_load_images

helm repo add hashicorp https://helm.releases.hashicorp.com
helm install --values consul-values.yaml consul hashicorp/consul --create-namespace --namespace consul --version "1.4.3"

export CONSUL_HTTP_TOKEN=$(kubectl get --namespace consul secrets/consul-bootstrap-acl-token --template={{.data.token}} | base64 -d)
export CONSUL_HTTP_ADDR=https://127.0.0.1:8501
export CONSUL_HTTP_SSL_VERIFY=false
