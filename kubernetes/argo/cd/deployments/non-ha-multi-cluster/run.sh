#/bin/bash
set -e
set -v

# Create K8S cluster
kind create cluster --name=non-ha-multi-cluster-1 --image=kindest/node:v1.28.7 --config=./kind-1.yaml
kind create cluster --name=non-ha-multi-cluster-2 --image=kindest/node:v1.28.7 --config=./kind-2.yaml

# Remove taints
# kubectl config use-context kind-non-ha-multi-cluster-1
# kubectl taint nodes $(kubectl get nodes --no-headers -o custom-columns=NAME:.metadata.name | grep control-plane) node-role.kubernetes.io/control-plane:NoSchedule-
# kubectl config use-context kind-non-ha-multi-cluster-2
# kubectl taint nodes $(kubectl get nodes --no-headers -o custom-columns=NAME:.metadata.name | grep control-plane) node-role.kubernetes.io/control-plane:NoSchedule-

# Install ArgoCD
kubectl config use-context kind-non-ha-multi-cluster-1
kubectl create namespace argocd
# kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/v2.9.14/manifests/install.yaml
kubectl apply -n argocd -f ./argocd-install.yaml

# Install ArgoCD CLI https://argo-cd.readthedocs.io/en/stable/cli_installation/
if [ ! -f /usr/local/bin/argocd ]; then
  curl -sSL -o argocd-linux-amd64 https://github.com/argoproj/argo-cd/releases/latest/download/argocd-linux-amd64
  sudo install -m 555 argocd-linux-amd64 /usr/local/bin/argocd
  rm -f ./argocd-linux-amd64
fi

# Helm
# if ! which helm >/dev/null; then
#   curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
#   sudo chmod 700 get_helm.sh
#   sudo ./get_helm.sh
#   rm -f ./get_helm.sh
# fi

# ingress-nginx and setting argocd ingress
# https://github.com/kubernetes/ingress-nginx/blob/main/charts/ingress-nginx/values.yaml
# https://github.com/kubernetes/ingress-nginx/blob/main/deploy/static/provider/kind/deploy.yaml
# helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
# helm repo update
# helm upgrade --install ingress-nginx ingress-nginx/ingress-nginx \
#   --namespace ingress-nginx --create-namespace \
#   --version 4.10.1 \
#   --set controller.image.registry=registry.lank8s.cn \
#   --set defaultBackend.image.registry=registry.lank8s.cn \
#   --set controller.admissionWebhooks.patch.image.registry=registry.lank8s.cn
# https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.10.1/deploy/static/provider/kind/deploy.yaml
kubectl apply -f ./ingress-manifests.yaml

# Wait for all pods to be ready
kubectl wait --for=condition=Ready pod --all --all-namespaces --timeout=60s -l app.kubernetes.io/component!=admission-webhook
kubectl get nodes -o wide

kubectl apply -f ./ingress-argocd.yaml

# Get password.  https://argo-cd.readthedocs.io/en/stable/getting_started/#4-login-using-the-cli
# Replace the IP address in ~/.kube/config with the new cluster IP.
kubectl config use-context kind-non-ha-multi-cluster-1
CLUSTER_1_IP=$(kubectl get node non-ha-multi-cluster-1-control-plane -o jsonpath='{.status.addresses[?(@.type=="InternalIP")].address}')
echo "CLuster_1_IP: $CLUSTER_1_IP"
kubectl config use-context kind-non-ha-multi-cluster-2
CLUSTER_2_IP=$(kubectl get node non-ha-multi-cluster-1-control-plane -o jsonpath='{.status.addresses[?(@.type=="InternalIP")].address}')
echo "CLuster_2_IP: $CLUSTER_2_IP"
ARGOCD_PASSWORD=$(kubectl get secrets argocd-initial-admin-secret -n argocd -o jsonpath="{.data.password}" | base64 -d)
argocd login argocd.linux88.com:443 --username admin --password $ARGOCD_PASSWORD
argocd cluster add kind-non-ha-multi-cluster-2
