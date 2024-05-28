#!/bin/bash
# https://docs.cilium.io/en/v1.15/network/servicemesh/grpc/"

set -e
set -v
set -u

cd "$(dirname "$0")"

kubectl apply -f ./manifests/microservices.yaml
kubectl apply -f ./manifests/grpc-ingress.yaml

# https://github.com/fullstorydev/grpcurl
kubectl wait --timeout=100s --for=condition=Ready=true pods --all -A
GRPC_INGRESS=$(kubectl get ingress grpc-ingress -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
# grpcurl -plaintext -proto ./demo.proto "$GRPC_INGRESS":80 hipstershop.CurrencyService/GetSupportedCurrencies
grpcurl -plaintext -proto ./demo.proto "$GRPC_INGRESS":80 hipstershop.ProductCatalogService/ListProducts
