## [Architecture](https://kubernetes.io/docs/concepts/architecture/)

![architecture](https://kubernetes.io/images/docs/kubernetes-cluster-architecture.svg)

- API Server 暴露了 Kubernetes API。所有的 Kubernetes 对象创建、读取、更新、删除操作都是通过 API Server 进行的。是 Kubernetes 集群中的 "大脑"，它处理和协调集群中的所有操作。

  1. **提供 RESTful API**：API Server 提供了 RESTful API，用户和其他控制平面组件可以通过这些 API 创建、获取、删除和更新 Kubernetes 资源。
  2. **处理 API 请求**：API Server 负责处理所有的 API 请求，并将其转化为对 etcd（Kubernetes 的持久化存储）的读写操作。
  3. **验证和授权**：API Server 还负责验证 API 请求的身份，并确定请求是否有权执行所请求的操作。
  4. **提供 watch 功能**：API Server 提供了 watch 功能，允许客户端实时监听资源的变化。

- etcd 用于持久化存储 Kubernetes 中所有集群数据。是 Kubernetes 集群的 "数据库"，它负责存储和保护集群的状态数据。

  1. **持久化存储**：etcd 提供了持久化存储功能，用于存储 Kubernetes 集群的所有数据，包括 Pods、Services、ReplicaSets 等资源对象的状态信息。
  2. **分布式键值存储**：etcd 是一个分布式键值存储系统，它使用 Raft 一致性算法来保证数据的一致性。
  3. **高可用性和容错性**：etcd 支持高可用性和容错性，可以在集群中的多个节点上运行，即使部分节点出现故障，也能保证数据的可用性。
  4. **与 API Server 的交互**：在 Kubernetes 集群中，只有 API Server 可以直接访问 etcd。其他组件，如 Scheduler、Kubelet、Kube-proxy 等，都通过 API Server 来读写 etcd 中的数据。

- Controller Manager 负责运行各种控制器。这些控制器负责将用户声明的高级资源转换为可以在节点上部署的低级资源。是实现 Kubernetes 自动化和自我修复能力的关键组件。

  1. **运行控制器**：Controller Manager 运行了一系列的控制器，如 Node Controller、Replication Controller、Endpoints Controller、Service Account & Token Controllers 等。
  2. **资源状态管理**：这些控制器会监视 Kubernetes API Server 上的资源对象，并确保实际状态与用户声明的期望状态一致。例如，如果你创建了一个 ReplicaSet 对象并指定了 3 个副本，ReplicaSet Controller 就会确保始终有 3 个 Pod 在运行。
  3. **与 API Server 交互**：所有的控制器都会与 API Server 进行交互，监视高级资源的变化，并创建、删除、更新低级资源以满足高级资源的规格。

- Scheduler 负责决定将 Pods 调度到哪个节点上运行。 是 Kubernetes 集群中的 "调度员"，它决定了 Pods 在集群中的分布，从而影响了集群的整体性能和效率。

  1. **资源调度**：Scheduler 负责将新创建的、还未分配到节点的 Pods 分配到合适的节点上。它会根据各种调度策略（如资源需求、硬件/软件/策略约束、亲和性和反亲和性规格、数据位置、工作负载间的干扰等）来决定最佳的节点。
  2. **与 API Server 交互**：Scheduler 会监听 API Server 上的 Pods 和 Nodes 的变化。当有新的未分配的 Pod 出现时，Scheduler 会决定将其调度到哪个节点上。调度决策完成后，Scheduler 会更新 Pod 的 `nodeName` 字段，将其绑定到选定的节点。

- Kubelet 是 Kubernetes 集群中每个节点上运行的代理，它负责管理节点上的工作负载。是 Kubernetes 集群中的 "工人"，它负责在节点上运行和管理 Pod 和容器。

  1. **Pod 生命周期管理**：Kubelet 负责启动、停止和维护 Pod。它根据 API Server 中的信息，确保节点上运行的 Pod 和容器的状态与 API Server 中的期望状态一致。
  2. **与 API Server 交互**：Kubelet 会定期向 API Server 报告节点的状态和 Pod 的状态，并从 API Server 获取分配给其节点的 Pod 的信息。
  3. **容器运行时接口**：Kubelet 使用容器运行时接口（CRI）与容器运行时进行交互，以管理容器的生命周期。这使得 Kubernetes 可以支持多种容器运行时，如 Docker、containerd、CRI-O 等。

- Kube-proxy 是 Kubernetes 集群中每个节点上运行的网络代理，它负责实现部分 Kubernetes Service 概念。是 Kubernetes 集群中的 "网络管理员"，它确保了 Service 的可访问性和网络的正确配置。

  1. **网络配置管理**：Kube-proxy 负责管理其所在节点的网络配置。它会监听 Kubernetes API Server 上的 Service 和 Endpoint 对象的变化，然后根据这些变化来更新节点上的网络规则。
  2. **服务发现和负载均衡**：Kube-proxy 通过配置 iptables 规则或 IPVS 来实现服务发现和负载均衡。当一个 Pod 尝试访问一个 Service 时，Kube-proxy 会将请求重定向到正确的后端 Pod。
  3. **与 API Server 交互**：Kube-proxy 会与 API Server 进行交互，获取 Service 和 Endpoint 的信息。
