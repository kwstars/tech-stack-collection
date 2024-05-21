## Command Line Tips and Tricks

```bash
# 设置上下文和命名空间
kubectl config set-context <context-of-question> --namespace=<namespace-of-question>

# 内部化资源短名称
kubectl api-resources

# 立即强制删除名为 "nginx" 的 Kubernetes Pod，不等待任何宽限期。
kubectl delete pod nginx --grace-period=0 --force

# 查找对象信息
kubectl describe pods | grep -C 10 "author=John Doe"
kubectl get pods -o yaml | grep -C 5 labels:
```

## Pods

### [Health Probe](https://github.com/k8spatterns/examples/tree/main/foundational/HealthProbe)

Liveness Probes、Readiness Probes 和 Startup Probes 都是 Kubernetes 中用于检测容器健康状态的探针机制，它们的作用如下：

- **Liveness Probes（存活探针）**：定期执行的健康检查，用于确认容器是否仍在运行。如果检查失败，kubelet 将重启该容器。它帮助确保应用程序在出现死锁或其他故障时能被重新启动。

- **Readiness Probes（就绪探针）**：用于检测容器是否准备好开始接收请求流量。如果检查失败，容器将从服务的端点中移除，不接收新的请求流量。它为容器提供了在启动阶段预热的机会，并在容器过载时暂时屏蔽请求流量。

- **Startup Probes（启动探针）**：与就绪探针类似，但是专门用于应对容器启动过程特别缓慢的情况。它的检查周期、重试次数和初始延迟都比就绪探针要大得多，以适应长时间启动。只有当启动探针成功后，才会开始执行就绪和存活探针检查。

资料: https://github.com/k8spatterns/examples/tree/main/foundational/HealthProbe

### [Lifecycle](https://kubernetes.io/docs/concepts/workloads/pods/pod-lifecycle/)

#### Signal

**SIGTERM**: 是一种温和的终止信号，用于通知容器正常退出。当 Pod 被删除或存活探针失败时，Kubernetes 会发送 SIGTERM，容器应尽快清理工作后正常退出，并有一个宽限期。

**SIGKILL**: 是一种强行终止信号，会直接杀死容器进程。如果容器在收到 SIGTERM 后的宽限期内未退出，Kubernetes 会发送 SIGKILL 强行终止，不给予清理机会，可能导致数据丢失或状态不一致。

应用需要正确处理 SIGTERM 信号，及时清理并优雅退出，避免收到 SIGKILL 信号强行终止，从而实现正常关停。设计良好的容器化应用应具备快速启动和关停的能力。

#### [Hooks](https://kubernetes.io/docs/concepts/containers/container-lifecycle-hooks/)

**PostStart** : 此钩子在容器创建完成后立即执行。但是无法保证钩子一定会在容器的 ENTRYPOINT 之前执行。它不接收任何参数传递给处理程序。

**PreStop**: 此钩子在容器因 API 请求或管理事件（如存活/启动探针失败、抢占、资源竞争等）即将被终止之前调用。如果容器已经处于终止或完成状态，则调用 PreStop 钩子将失败，并且钩子必须在发送 TERM 信号停止容器之前完成。Pod 的终止宽限期会在 PreStop 钩子执行之前开始计时，所以无论处理程序的结果如何，容器最终都会在 Pod 的终止宽限期内终止。它也不接收任何参数传递给处理程序。

总的来说，PostStart 钩子用于在容器启动完成后执行一些初始化操作；而 PreStop 钩子则用于在容器终止前执行一些清理操作，让应用可以安全地进行状态持久化等工作。这两个钩子为容器提供了生命周期中的扩展点。

资料: https://github.com/k8spatterns/examples/blob/main/foundational/ManagedLifecycle/README.adoc

### Multi-Container Pods

- **[Init Container](https://github.com/k8spatterns/examples/tree/main/structural/InitContainer)**: 用于在应用容器启动之前完成一些初始化工作，比如安装工具、设置权限、配置数据等。它允许将初始化逻辑与应用本身的主要职责分离开来。
- **[Sidecar](https://github.com/k8spatterns/examples/tree/main/structural/Sidecar)**: 通过一个"伴生"的辅助容器来扩展或加强主容器的功能。伴生容器可以提供如日志记录、代理、监控采集等辅助性的能力，增强主容器的功能而不须修改主容器自身。
- **[Adapter](https://github.com/k8spatterns/examples/tree/main/structural/Adapter)**: 用于在具有不同技术实现的异构组件之间提供统一的访问接口。它隐藏了底层组件的复杂性，为上层提供了统一且友好的操作方式。
- **[Ambassador](https://github.com/k8spatterns/examples/tree/main/structural/Ambassador)**: 将访问外部服务的相关逻辑从应用容器中分离出来，放入一个代理容器中统一处理。这样应用容器只关注自身的业务逻辑，外部服务的访问细节全权交由 Ambassador 容器处理。

## [Deployment](https://github.com/k8spatterns/examples/tree/main/foundational/DeclarativeDeployment)

## [Scheduling](https://kubernetes.io/docs/concepts/scheduling-eviction/)

- **Available Node Resources**: 这是 Kubernetes 调度器考虑的基本因素，它会根据节点上可用的 CPU 和内存资源来决定在哪个节点上运行 Pod。

- **[Container Resource Demands](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/)**: Pod 的资源需求（如 CPU 和内存）会影响调度决策。如果一个节点无法满足 Pod 的资源需求，那么这个 Pod 就不会被调度到这个节点上。

- **[Scheduler Configurations](https://kubernetes.io/docs/reference/scheduling/config/)**: Kubernetes 调度器的行为可以通过配置进行调整。例如，你可以配置调度器优先考虑最少负载的节点，或者优先考虑最近添加的节点。

- **[Scheduling Process](https://kubernetes.io/docs/concepts/scheduling-eviction/scheduling-framework/)**: Kubernetes 调度器在调度 Pod 时会经过一系列的步骤，包括过滤不合适的节点，打分，然后选择得分最高的节点。或通过 Pod 的 [nodeSelector](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#nodeselector) 字段指定节点。

- **[Node Affinity](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#node-affinity)**: Node Affinity 是一种可以让 Pod 更倾向于被调度到符合特定条件的节点的机制。例如，你可以设置一个 Pod 只能运行在具有特定标签的节点上。

  - `requiredDuringSchedulingIgnoredDuringExecution`: 表示在调度时必须满足的条件，如果没有节点满足这些条件，Pod 将无法被调度；但一旦 Pod 被调度并运行，即使这些条件后来不再满足，也不会影响已经运行的 Pod。

  - `preferredDuringSchedulingIgnoredDuringExecution`: 调度时会尽量满足这里设置的亲和性条件，但不是强制要求，可以调度到不满足条件的节点上。

- **[Pod Affinity and Anti-Affinity](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#inter-pod-affinity-and-anti-affinity)**: Pod Affinity 和 Anti-Affinity 可以让 Pod 更倾向于被调度到运行着特定 Pod 的节点，或者不被调度到运行着特定 Pod 的节点。

- **[Topology Spread Constraints](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#pod-topology-spread-constraints)**: Topology Spread Constraints 可以用来控制 Pod 在拓扑域（如区域和节点）中的分布。例如，你可以设置一个 Pod 在每个区域中至少有一个副本。

- **[Taints and Tolerations](https://kubernetes.io/docs/concepts/scheduling-eviction/taint-and-toleration/)**: Taints 和 Tolerations 是一种可以阻止某些 Pod 被调度到某些节点的机制。例如，你可以在一个节点上添加一个 Taint，然后只有具有相应 Toleration 的 Pod 才能被调度到这个节点上。

- **[Pod Priority and Preemption](https://kubernetes.io/docs/concepts/scheduling-eviction/pod-priority-preemption/)**: Pod Priority 和 Preemption 可以让你设置 Pod 的优先级，以及在资源不足时优先调度高优先级的 Pod。

资料：https://github.com/k8spatterns/examples/tree/main/foundational/AutomatedPlacement

## [Storage](https://kubernetes.io/docs/concepts/storage/)

### [Volume types](https://kubernetes.io/docs/concepts/storage/volumes/)

- 本地存储卷

  - `emptyDir`：emptyDir 是 Kubernetes 中的一种临时存储卷类型，它在 Pod 被分配到节点时创建，并且最初是空的。Pod 中的所有容器都可以读写该卷中的文件，但当 Pod 从节点上移除时，emptyDir 卷中的数据会被永久删除。emptyDir 卷常用于提供临时空间供容器使用，如磁盘排序、长计算的检查点、内容管理器获取数据等场景。可以通过 emptyDir.medium 字段控制存储介质，默认使用节点上的存储介质，也可指定为基于内存的 tmpfs。emptyDir 卷还可以配置存储大小限制。
  - `hostPath`：hostPath 卷类型允许你将主机节点的文件系统中的文件或目录挂载到 Pod 中，但这带来了许多安全风险，因此除非必要，否则应避免使用。
  - `local`：Local volume 代表挂载的本地存储设备，如磁盘、分区或目录。它只能用作静态创建的 PersistentVolume，不支持动态 provisioning。与 hostPath volume 相比，local volume 以更持久和可移植的方式使用，不需手动将 pod 调度到节点上，系统会根据 PV 上的节点亲和性约束了解 volume 所在节点。但 local volume 受限于底层节点的可用性，如果节点出现故障就会无法访问，因此不适合所有应用，需要能够容忍这种可用性降低和潜在数据丢失。在使用时必须设置 PV 的 nodeAffinity，以让调度器能够正确调度 pod 到对应节点。local volume 还支持以 "Block" 模式暴露为原始块设备。推荐创建 StorageClass 时将 volumeBindingMode 设为 WaitForFirstConsumer，以确保 PVC 绑定也考虑 pod 的其他约束。还可以运行外部 provisioner 来改善 local volume 生命周期管理。

- 网络存储卷

  - `nfs`：允许你挂载 NFS 共享。
  - `glusterfs`：允许你挂载 GlusterFS 卷。
  - `cifs`：允许你挂载 SMB (Server Message Block) 共享。
  - `iscsi`：允许你挂载 iSCSI 共享。

- 云提供商存储卷

  - `awsElasticBlockStore`：AWS EBS 卷。
  - `azureDisk`：Azure 磁盘存储。
  - `azureFile`：Azure 文件存储。
  - `gcePersistentDisk`：GCE 持久磁盘。

- 分布式文件系统

  - `cephfs`：允许你挂载 CephFS 卷。
  - `rbd`：允许你挂载 Ceph RBD。

- 特殊用途卷

  - `configMap`、`secret`、`downwardAPI`：用于将 Kubernetes 对象和集群信息暴露给 Pod。
  - `persistentVolumeClaim`：用于使用预先配置的持久卷。

- 其他

  - `csi`：容器存储接口 (CSI) 卷。
  - `flexVolume`：用于使用外部驱动程序的卷。
  - `storageos`：用于使用 StorageOS 的卷。

### [PV（PersistentVolume）](https://kubernetes.io/docs/concepts/storage/persistent-volumes/)

在 Kubernetes 中，PersistentVolume (PV) 的 `spec` 字段包含了一些重要的选项，如下：

- **capacity**：存储容量，这是 PV 的大小。这是必需字段。

- **[accessModes](https://kubernetes.io/docs/concepts/storage/persistent-volumes/#access-modes)**：PV 的访问模式。

  - `ReadWriteOnce`: 存储卷可以被单个节点以读写方式挂载。但如果多个 Pod 在同一节点上运行，它们仍然可以访问该存储卷。
  - `ReadOnlyMany`: 存储卷可以被多个节点以只读方式挂载。
  - `ReadWriteMany`: 存储卷可以被多个节点以读写方式挂载。
  - `ReadWriteOncePod`: 存储卷可以被单个 Pod 以读写方式挂载。

- **[persistentVolumeReclaimPolicy](https://kubernetes.io/docs/concepts/storage/persistent-volumes/#reclaiming)**：当 PVC 不再需要 PV 时，Kubernetes 会执行的操作。

  - `Retain`: 保留 PV。
  - `Delete`: 删除 PV。
  - `Recycle`: 回收 PV，已弃用。

- **storageClassName**：PV 所属的 StorageClass。如果 PVC 指定了 StorageClass，那么只有标记为该 StorageClass 的 PV 才能与之绑定。

- **[mountOptions](https://kubernetes.io/docs/concepts/storage/persistent-volumes/#mount-options)**：挂载到主机的选项。

- **volumeMode**：PV 的卷模式，可以是 "Filesystem" 或者 "Block"。

- **nodeAffinity**：定义了 PV 可以绑定的 Node 的限制。

#### [状态](https://kubernetes.io/docs/concepts/storage/persistent-volumes/#phase)

在 Kubernetes 中，PersistentVolume（PV）会处于以下几种状态之一：

- **Available**：这是一个尚未绑定到 PersistentVolumeClaim（PVC）的空闲资源。
- **Bound**：该卷已绑定到一个 PVC。
- **Released**：PVC 已被删除，但集群尚未回收关联的存储资源。
- **Failed**：卷的自动回收失败。

### [PVC（PersistentVolumeClaim）](https://kubernetes.io/docs/concepts/storage/persistent-volumes/#persistentvolumeclaims)

在 Kubernetes 中，PersistentVolumeClaim (PVC) 的 `spec` 字段包含了一些重要的选项，如下：

- **accessModes**：PVC 的访问模和 PV 的一样。

- **resources**：PVC 所请求的存储资源。这通常包括 `requests` 字段，用于指定所需的存储容量。

- **storageClassName**：PVC 所请求的 StorageClass。如果指定了 StorageClass，那么只有标记为该 StorageClass 的 PV 才能与之绑定。如果没有指定，将使用默认的 StorageClass。

- **volumeName**：PVC 可以指定一个特定的 PV 来绑定。如果指定了这个字段，那么 Kubernetes 将尝试将 PVC 绑定到这个特定的 PV，而不是根据 StorageClass 和容量需求选择一个 PV。

- **selector**：PVC 可以通过标签选择器来选择 PV。只有标签匹配的 PV 才会被考虑用于绑定。

### [StorageClass](https://kubernetes.io/docs/concepts/storage/storage-classes/)

在 Kubernetes 中，StorageClass 的 `spec` 字段包含了一些重要的选项，如下：

- **provisioner**：用于动态供应 PV 的插件的名称。例如，`kubernetes.io/aws-ebs` 用于 AWS EBS，`kubernetes.io/gce-pd` 用于 GCE PD。

- **parameters**：供应者特定的参数，用于配置动态供应的 PV。这些参数因供应者而异。

- **reclaimPolicy**：当 PVC 使用完并被删除时，定义 PV 应该如何处理。可以是 "Delete" 或 "Retain"。

- **volumeBindingMode**：定义了 PV 和 PVC 之间的绑定方式。可以是 "Immediate" 或 "WaitForFirstConsumer"。

- **allowedTopologies**：限制供应的 PV 可以存在的拓扑。这可以用于限制动态供应的 PV 在特定的区域或节点。

## Network

### [Services](https://kubernetes.io/docs/concepts/services-networking/service/#publishing-services-service-types)

- `ClusterIP`: 这是默认的 Service 类型，它会给 Service 分配一个只能在集群内部访问的 IP 地址。
- `NodePort`: 这种类型的 Service 除了拥有一个 ClusterIP，还在每个节点上开放一个端口，使得 Service 可以从集群外部通过 `<NodeIP>:<NodePort>` 的方式访问。
- `LoadBalancer`: 支持外部负载均衡器的云提供商环境中，将服务类型设置为 LoadBalancer 会为该服务提供一个外部负载均衡器，自动将流量转发到后端 Pod 上。这种服务类型常用于向公网暴露 Web 服务、API 服务等，实现自动负载均衡和高可用。
- `ExternalName`: 这种类型的 Service 允许你将 Service 映射到 `externalName` 字段的内容（例如，`foo.bar.example.com`），没有任何类型代理被创建。这种类型的 Service 对于一些特殊的服务发现用途非常有用。
- `Headless`: 这种类型的 Service 不会分配 ClusterIP，它会将 Service 的 DNS 记录解析为 Service 的 Endpoints 的集合。这种类型的 Service 通常用于 StatefulSet。

## Configuration

- **[EnvVar Configuration](https://github.com/k8spatterns/examples/tree/main/configuration/EnvVarConfiguration)**: 这是一种通过环境变量来配置应用的方法。在 Kubernetes 中，你可以在 Pod 的定义中设置环境变量，然后在应用中使用这些环境变量。这种方法简单易用，但不适合存储敏感信息，如密码和密钥。

- **[Configuration Resource](https://github.com/k8spatterns/examples/tree/main/configuration/ConfigurationResource)**: Kubernetes 提供了 ConfigMap 和 Secret 这两种资源类型，用于存储配置信息。ConfigMap 用于存储普通的配置数据，而 Secret 用于存储敏感信息。这些资源可以被 Pod 引用，并以环境变量或文件的形式提供给应用。

- **[Immutable Configuration](https://github.com/k8spatterns/examples/tree/main/configuration/ImmutableConfiguration)**: 这是一种将配置信息直接嵌入到容器镜像中的方法。这种方法可以确保配置信息的一致性和不可变性，但更新配置信息时需要重新构建和部署镜像。

- **[Configuration Template](https://github.com/k8spatterns/examples/tree/main/configuration/ConfigurationTemplate)**: 这是一种动态生成配置文件的方法。你可以创建一个包含占位符的配置文件模板，然后在部署应用时，使用实际的配置值替换这些占位符。Kubernetes 的 ConfigMap 和 Secret 可以用于存储这些配置值。

## [Security](https://kubernetes.io/docs/concepts/security/)

### [进程隔离](https://github.com/k8spatterns/examples/tree/main/security/ProcessContainment)

- **以非 root 用户运行容器**：默认情况下，容器以 root 用户身份运行，这可能会导致安全问题。你可以通过在 Pod 规范中设置 `securityContext` 来以非 root 用户运行容器。

- **限制容器能力**：你可以通过 `securityContext` 来限制容器的 Linux 能力，以减少容器可能被利用的风险。

- **避免可变的容器文件系统**：你可以通过设置 `securityContext` 中的 `readOnlyRootFilesystem` 为 `true` 来使容器的文件系统为只读。

### 网络分段

- **网络策略**：你可以使用 Kubernetes 网络策略来控制 Pod 之间的网络流量。

- **身份验证策略**：你可以使用 Kubernetes 的身份验证策略来控制谁可以访问你的集群。

### 安全配置

- **集群外加密**：你可以使用 Kubernetes 的加密解决方案（如 KMS 提供商）来加密存储在 etcd 中的敏感数据。

- **集中式的 Secret 管理**：你可以使用 Kubernetes 的 Secret 对象或者第三方解决方案（如 HashiCorp Vault）来集中管理敏感数据。

### 访问控制

- **身份验证**：Kubernetes 提供了多种身份验证方法，包括基于证书的身份验证、基于令牌的身份验证等。

- **授权**：Kubernetes 使用 Role-Based Access Control (RBAC) 来控制用户和 Service Account 对资源的访问权限。

- **准入控制器**：准入控制器是一种插件，它可以在创建、修改或删除资源时执行一些检查。

- **主题**：在 RBAC 中，主题可以是用户、组或者 Service Account。

- **基于角色的访问控制**：RBAC 允许你根据角色来控制谁可以访问哪些 Kubernetes 资源。

## Elastic Scale

## 参考和引用

- [Getting started](https://kubernetes.io/docs/setup/)
- [The Kubernetes Book](https://github.com/nigelpoulton/TheK8sBook)
- [Certified Kubernetes Application Developer (CKAD) Study Guide](https://github.com/bmuschko/ckad-study-guide)
- [CKAD](https://www.cncf.io/training/certification/ckad/)
- [CKAD Exercises](https://github.com/dgkanatsios/CKAD-exercises)
- [Certified Kubernetes Administrator (CKA) Study Guide](https://github.com/bmuschko/cka-study-guide)
- [Certified Kubernetes Administrator - CKA Course](https://github.com/kodekloudhub/certified-kubernetes-administrator-course)
- [Certified Kubernetes Security Specialist (CKS) Study Guide](https://github.com/bmuschko/cks-study-guide)
- [killer.sh](https://killer.sh/)
- [CKA practice exam from Study4Exam](https://www.study4exam.com/linux-foundation/info/cka)
- [Kubernetes Patterns, 2nd Edition](https://github.com/k8spatterns)
