#!/bin/bash

# 检查 insecure-registries 是否已经包含目标地址
# sudo tee /etc/docker/daemon.json <<EOF
# {
#   "insecure-registries" : ["10.0.0.10:5000"]
# }
# EOF

# 定义镜像仓库地址 mcr.microsoft.com/oss/kubernetes
registry="registry.aliyuncs.com/google_containers"
target="10.0.0.10:5000"

# Kind 镜像
# kubectl get pods --all-namespaces -o jsonpath="{..image}" | tr -s '[[:space:]]' '\n' | sort | uniq
images=(
  "kube-apiserver-amd64:v1.28.7"
  "kube-apiserver:v1.28.7"
  "kube-controller-manager-amd64:v1.28.7"
  "kube-controller-manager:v1.28.7"
  "kube-scheduler-amd64:v1.28.7"
  "kube-scheduler:v1.28.7"
  "kube-proxy-amd64:v1.28.7"
  "kube-proxy:v1.28.7"
  "coredns:1.10.1"
  "etcd:3.5.10-0"
)

# 遍历镜像列表
for image in "${images[@]}"; do
  # 拉取镜像
  docker pull "$registry/$image"

  docker tag "$registry/$image" "$target/$image"

  docker push "$target/$image"
done

# Flannel
docker pull docker.io/flannel/flannel-cni-plugin:v1.4.0-flannel1
docker pull docker.io/flannel/flannel:v0.24.4
