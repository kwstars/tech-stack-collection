#!/bin/bash
set -e
set -v

cd "$(dirname "$0")"

readonly LAB_NAME=$1

function pull_and_retag_images() {
  local SOURCE_REGISTRY=$1
  local TARGET_REGISTRY=$2
  local IMAGES=(
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
pull_and_retag_images "k8s.dockerproxy.com" "registry.k8s.io"
docker pull wbitt/network-multitool
kind load docker-image wbitt/network-multitool --name "$LAB_NAME"

controller_node=$(kubectl get nodes --no-headers -o custom-columns=NAME:.metadata.name | grep control-plane)
# controller_node_ip=$(kubectl get node "$controller_node" -o jsonpath='{.status.addresses[?(@.type=="InternalIP")].address}')
kubectl taint nodes "$controller_node" node-role.kubernetes.io/control-plane:NoSchedule-

# Install ingress-nginx https://kind.sigs.k8s.io/docs/user/ingress/#ingress-nginx
kubectl apply -f ingress-nginx.yaml
kubectl wait --for=condition=ready pod -l app.kubernetes.io/component=controller -n ingress-nginx

KEY_FILE="./key.pem"
CERT_FILE="./cert.pem"
HOST="foo.bar.com"
CERT_NAME="my-tls-secret"

# Generate a self-signed certificate and private key
openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout ${KEY_FILE} -out ${CERT_FILE} -subj "/CN=${HOST}/O=${HOST}" -addext "subjectAltName = DNS:${HOST}"

# Create the secret
kubectl create secret tls ${CERT_NAME} --key ${KEY_FILE} --cert ${CERT_FILE}
kubectl apply -f https.yaml

kubectl wait --for=condition=ready pod -l app=http-app
# curl -v https://127.0.0.1:8443 -H 'Host: foo.bar.com'
curl https://127.0.0.1:8443 -H 'Host: foo.bar.com' -k
