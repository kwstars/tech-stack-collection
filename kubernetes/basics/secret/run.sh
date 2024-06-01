#!/bin/bash
set -e
set -v

cd "$(dirname "$0")"

kubectl create secret tls my-tls-secret --cert=tls.crt --key=tls.key

cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Secret
metadata:
  name: secret-ssh-auth
type: kubernetes.io/ssh-auth
data:
  # the data is abbreviated in this example
  ssh-privatekey: |
    UG91cmluZzYlRW1vdGljb24lU2N1YmE=
EOF
