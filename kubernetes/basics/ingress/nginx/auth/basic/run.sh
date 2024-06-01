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

# https://kubernetes.github.io/ingress-nginx/examples/auth/basic/
sudo apt install -y apache2-utils
# htpasswd -b -c auth foo bar
# htpasswd -b auth foo2 bar2
auth_content1=$(htpasswd -nb foo bar)
auth_content2=$(htpasswd -nb foo2 bar2)
auth_content="$auth_content1
$auth_content2"
echo $auth_content

if kubectl get secret basic-auth >/dev/null 2>&1; then
  kubectl delete secret basic-auth
fi
# kubectl create secret generic basic-auth --from-file=auth
kubectl create secret generic basic-auth --from-literal=auth="$auth_content"
kubectl get secret basic-auth -o yaml

cat <<EOF | kubectl apply -f -
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: ingress-with-auth
  annotations:
    # type of authentication
    nginx.ingress.kubernetes.io/auth-type: basic
    # name of the secret that contains the user/password definitions
    nginx.ingress.kubernetes.io/auth-secret: basic-auth
    # message to display with an appropriate context why the authentication is required
    nginx.ingress.kubernetes.io/auth-realm: 'Authentication Required - foo'
spec:
  ingressClassName: nginx
  rules:
  - host: foo.bar.com
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: http-svc
            port:
              number: 80
---
# deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: http-app
spec:
  replicas: 3
  selector:
    matchLabels:
      app: http-app
  template:
    metadata:
      labels:
        app: http-app
    spec:
      containers:
      - name: http-app
        image: wbitt/network-multitool
        ports:
        - containerPort: 80
---
apiVersion: v1
kind: Service
metadata:
  name: http-svc
spec:
  selector:
    app: http-app
  ports:
    - protocol: TCP
      port: 80
      targetPort: 80
EOF

kubectl wait --for=condition=ready pod -l app=http-app
curl -v http://127.0.0.1:8080 -H 'Host: foo.bar.com'
curl -v http://127.0.0.1:8080 -H 'Host: foo.bar.com' -u 'foo:bar'
