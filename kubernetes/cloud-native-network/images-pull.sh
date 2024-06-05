#!/bin/bash

# 检查 insecure-registries 是否已经包含目标地址
# sudo tee /etc/docker/daemon.json <<EOF
{
  "insecure-registries" : ["10.0.0.10:5000"]
}
# EOF

# 定义镜像仓库地址 mcr.microsoft.com/oss/kubernetes
registry="registry.aliyuncs.com/google_containers"
target="10.0.0.10:5000"

# Kind 镜像
# kubectl get pods --all-namespaces -o jsonpath="{..image}" | tr -s '[[:space:]]' '\n' | sort | uniq
# for name in $(docker image ls | awk 'NR>1 {print $1":"$2}'); do newName=${name//\//\-}; docker save $name | gzip > "$newName.tar.gz"; done
# for name in $(ls); do docker load -i $name; done
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
# Flannel 的 CNI 插件。CNI（Container Network Interface）是一个标准的插件接口，用于在容器启动时设置网络，并在容器停止时清理网络。Flannel 的 CNI 插件用于在 Kubernetes 集群中实现网络覆盖。
docker pull docker.io/flannel/flannel-cni-plugin:v1.4.0-flannel1
# Flannel 的 Overlay Proxy。
docker pull docker.io/flannel/flannel:v0.25.1

# Calico
# Calico 的 CNI 插件。CNI（Container Network Interface）是一个标准的插件接口，用于在容器启动时设置网络，并在容器停止时清理网络。Calico 的 CNI 插件用于在 Kubernetes 集群中实现网络策略和网络路由。
docker pull docker.io/calico/cni:v3.27.3
# Calico 的 Kubernetes 控制器。这个控制器用于监控 Kubernetes API，并根据网络策略和网络路由的变化更新 Calico 网络。
docker pull docker.io/calico/kube-controllers:v3.27.3
# Calico 的节点代理。这个代理在每个 Kubernetes 节点上运行，实现网络策略和网络路由。
docker pull docker.io/calico/node:v3.27.3
