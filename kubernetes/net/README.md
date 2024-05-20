## 流量分类

Kubernetes 的流量主要可以分为以下几类：

1. **集群内部流量**：这是在 Kubernetes 集群内部，Pod 之间的通信。这包括：

   - 同一主机上的 Pod 之间的通信：这种通信通常通过 Linux 的网络命名空间和 veth pair（虚拟以太网对）实现。
   - 跨主机的 Pod 之间的通信：这种通信通常需要网络插件（如 Flannel、Calico 等）的支持，以实现 Pod 网络的路由和互通。

2. **集群外部流量**：这是从 Kubernetes 集群外部到集群内部（或反向）的通信。这包括：

   - 从外部到集群内部的服务访问：这种通信通常通过 Kubernetes 的 Service 和 Ingress 实现，可能需要负载均衡器或反向代理的支持。
   - 从集群内部到外部的访问：这种通信通常通过 NAT（网络地址转换）或直接路由实现。

3. **控制面流量**：这是 Kubernetes 控制面组件（如 API server、scheduler、controller manager 等）之间，以及它们与工作节点和 Pod 之间的通信。这种通信通常通过 Kubernetes API server 的安全端口实现，需要 TLS 加密和身份验证。

## [CNI 实现](https://www.cni.dev/)

在 Kubernetes 中，CNI（Container Network Interface）是一种标准的插件接口，用于配置和管理容器的网络连接。以下是一些常见的 CNI 实现：

1. **Flannel**：Flannel 是一种简单的 Overlay 网络插件，它支持多种 Overlay 网络类型，包括 VXLAN、UDP 和 Host-gw 等。
2. **Calico**：Calico 是一种高性能的网络插件，它支持 Overlay 网络（使用 IPIP 或 VXLAN）和 Underlay 网络（使用 BGP 路由）。Calico 还提供了网络策略功能，用于控制 Pod 之间的网络流量。
3. **Weave**：Weave 是一种 Overlay 网络插件，它使用自己的路由和发现协议，可以在没有外部数据库或集群存储的情况下工作。
4. **Cilium**：Cilium 是一种新的网络插件，它使用 BPF（Berkeley Packet Filter）技术来提供高性能的网络和安全功能。
5. **Kube-router**：Kube-router 是一种简单的网络插件，它使用 IPVS/LVS（Linux Virtual Server）和 BGP（Border Gateway Protocol）来提供网络和负载均衡功能。
6. **Multus**：Multus 不是一个传统意义上的网络插件，而是一个 Meta 插件，它允许一个 Pod 同时连接到多个网络。

## 参考和引用

- [Container Network Interface (CNI) Specification](https://github.com/containernetworking/cni/blob/main/SPEC.md)
- https://www.alibabacloud.com/blog/getting-started-with-kubernetes-%7C-kubernetes-cnis-and-cni-plug-ins_596330
- https://gitee.com/rowan-wcni/projects
- https://www.yuque.com/wei.luo/network
- [Networking and Kubernetes](https://www.oreilly.com/library/view/networking-and-kubernetes/9781492081647/)
- [The Almighty Pause Container](https://www.ianlewis.org/en/almighty-pause-container)
- [KIND and Load Balancing with MetalLB on Mac](https://www.thehumblelab.com/kind-and-metallb-on-mac/)
