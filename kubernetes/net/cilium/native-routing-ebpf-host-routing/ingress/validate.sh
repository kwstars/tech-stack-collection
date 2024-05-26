#!/bin/bash

# https://docs.cilium.io/en/v1.15/network/servicemesh/http/

function load_images_into_kind() {
  local images=(
    docker.io/istio/examples-bookinfo-details-v1:1.16.2
    docker.io/istio/examples-bookinfo-ratings-v1:1.16.2
    docker.io/istio/examples-bookinfo-reviews-v1:1.16.2
    docker.io/istio/examples-bookinfo-productpage-v1:1.16.2
  )

  local cluster_name
  cluster_name=$(kind get clusters)
  for image in "${images[@]}"; do
    docker pull "$image"
    kind load docker-image "$image" --name "$cluster_name"
  done
}

load_images_into_kind

# Deploy the Demo App
kubectl apply -f https://raw.githubusercontent.com/istio/istio/release-1.11/samples/bookinfo/platform/kube/bookinfo.yaml

# Deploy the First Ingress
kubectl apply -f https://raw.githubusercontent.com/cilium/cilium/v1.15/examples/kubernetes/servicemesh/basic-ingress.yaml

kubectl wait --timeout=100s --for=condition=Ready=true pods --all -A

kubectl get svc

kubectl get ingress

HTTP_INGRESS=$(kubectl get ingress basic-ingress -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
curl --fail -s http://"$HTTP_INGRESS"/details/1 | jq
