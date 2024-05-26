#!/bin/bash

set -e

cd "$(dirname "$0")"

function http_test() {
  # Deploy the Bookinfo Application, https://raw.githubusercontent.com/istio/istio/release-1.11/samples/bookinfo/platform/kube/bookinfo.yaml
  kubectl apply -f ./manifests/bookinfo.yaml

  # Deploy the http, https://raw.githubusercontent.com/cilium/cilium/v1.15/examples/kubernetes/servicemesh/basic-ingress.yaml
  kubectl apply -f ./manifests/basic-ingress.yaml

  # Wait for all pods to be ready
  kubectl wait --timeout=100s --for=condition=Ready=true pods --all -A

  # Test HTTP ingress
  kubectl wait --timeout=100s --for=condition=Ready=true pods --all -A
  HTTP_INGRESS=$(kubectl get ingress basic-ingress -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
  curl --fail -s http://"$HTTP_INGRESS"/details/1 | jq
}

function grpc_test() {
  kubectl apply -f ./manifests/microservices.yaml
  kubectl apply -f ./manifests/grpc-ingress.yaml
  # kubectl get ingress
  # https://github.com/fullstorydev/grpcurl
  kubectl wait --timeout=100s --for=condition=Ready=true pods --all -A
  GRPC_INGRESS=$(kubectl get ingress grpc-ingress -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
  grpcurl -plaintext -proto ./demo.proto "$GRPC_INGRESS":80 hipstershop.CurrencyService/GetSupportedCurrencies
  grpcurl -plaintext -proto ./demo.proto "$GRPC_INGRESS":80 hipstershop.ProductCatalogService/ListProducts
}

function tls_test() {
  helm repo add jetstack https://charts.jetstack.io
  helm upgrade --install cert-manager jetstack/cert-manager --version v1.12.10 \
    --namespace cert-manager \
    --set installCRDs=true \
    --create-namespace

  kubectl apply -f ./manifests/microservices.yaml
  kubectl apply -f ./manifests/bookinfo.yaml

  # Create a CA Issuer, https://raw.githubusercontent.com/cilium/cilium/v1.15/examples/kubernetes/servicemesh/ca-issuer.yaml
  kubectl apply -f ./manifests/ca-issuer.yaml

  # Deploy the https, https://raw.githubusercontent.com/cilium/cilium/v1.15/examples/kubernetes/servicemesh/tls-ingress.yaml
  kubectl apply -f ./manifests/tls-ingress.yaml

  # To tell cert-manager that this Ingress needs a certificate
  kubectl annotate ingress tls-ingress cert-manager.io/issuer=ca-issuer

  # kubectl get certificate,secret demo-cert

  # Test TLS ingress
  kubectl wait --timeout=100s --for=condition=Ready=true pods --all -A
  sudo sed -i '/\.cilium\.rocks$/d' /etc/hosts
  sudo tee -a /etc/hosts <<<"$(kubectl get ing tls-ingress -o=jsonpath='{.status.loadBalancer.ingress[0].ip}') bookinfo.cilium.rocks hipstershop.cilium.rocks"
  curl -k https://bookinfo.cilium.rocks/details/1
  kubectl get secret demo-cert -o jsonpath="{.data['ca\.crt']}" | base64 --decode >/tmp/minica.pem
  grpcurl -proto ./demo.proto -cacert /tmp/minica.pem hipstershop.cilium.rocks:443 hipstershop.ProductCatalogService/ListProducts
}

# http example, https://docs.cilium.io/en/v1.15/network/servicemesh/http/
# http_test

# grpc example, https://docs.cilium.io/en/v1.15/network/servicemesh/grpc/
# grpc_test

# tls, https://docs.cilium.io/en/v1.15/network/servicemesh/tls-termination/
tls_test
