#!/bin/bash
# https://docs.cilium.io/en/v1.15/network/servicemesh/tls-termination/

set -e
set -v

cd "$(dirname "$0")"

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

# Wait for the certificate to be issued
kubectl wait --timeout=100s --for=condition=Ready=true pods --all -A
kubectl get certificate,secret demo-cert
kubectl get secret demo-cert -o jsonpath="{.data.ca\.crt}" | base64 --decode | openssl x509 -noout -text
kubectl get secret demo-cert -o jsonpath="{.data.tls\.key}" | base64 --decode | openssl rsa -check -noout
kubectl get secret demo-cert -o jsonpath="{.data.tls\.crt}" | base64 --decode | openssl x509 -noout -text | grep -A1 'Subject Alternative Name'

# Add the following to /etc/hosts
sudo sed -i '/\.cilium\.rocks$/d' /etc/hosts
sudo tee -a /etc/hosts <<<"$(kubectl get ing tls-ingress -o=jsonpath='{.status.loadBalancer.ingress[0].ip}') bookinfo.cilium.rocks hipstershop.cilium.rocks"

# Test TLS ingress
curl -k https://bookinfo.cilium.rocks/details/1
kubectl get secret demo-cert -o jsonpath="{.data['ca\.crt']}" | base64 --decode >/tmp/minica.pem
grpcurl -proto ./demo.proto -cacert /tmp/minica.pem hipstershop.cilium.rocks:443 hipstershop.ProductCatalogService/ListProducts
