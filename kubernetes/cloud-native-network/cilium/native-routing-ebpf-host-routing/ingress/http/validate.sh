#!/bin/bash
# https://docs.cilium.io/en/v1.15/network/servicemesh/http/

set -e
set -v

cd "$(dirname "$0")"

# Deploy the Bookinfo Application, https://raw.githubusercontent.com/istio/istio/release-1.11/samples/bookinfo/platform/kube/bookinfo.yaml
kubectl apply -f ./manifests/bookinfo.yaml

# Deploy the http, https://raw.githubusercontent.com/cilium/cilium/v1.15/examples/kubernetes/servicemesh/basic-ingress.yaml
kubectl apply -f ./manifests/basic-ingress.yaml

# Test HTTP ingress
kubectl wait --timeout=100s --for=condition=Ready=true pods --all -A
HTTP_INGRESS=$(kubectl get ingress basic-ingress -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
curl --fail -s http://"$HTTP_INGRESS"/details/1 | jq
