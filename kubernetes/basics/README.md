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

## [Services](https://kubernetes.io/docs/concepts/services-networking/service/#publishing-services-service-types)

- `ClusterIP`: 这是默认的 Service 类型，它会给 Service 分配一个只能在集群内部访问的 IP 地址。
- `NodePort`: 这种类型的 Service 除了拥有一个 ClusterIP，还在每个节点上开放一个端口，使得 Service 可以从集群外部通过 `<NodeIP>:<NodePort>` 的方式访问。
- `LoadBalancer`: 支持外部负载均衡器的云提供商环境中，将服务类型设置为 LoadBalancer 会为该服务提供一个外部负载均衡器，自动将流量转发到后端 Pod 上。这种服务类型常用于向公网暴露 Web 服务、API 服务等，实现自动负载均衡和高可用。
- `ExternalName`: 这种类型的 Service 允许你将 Service 映射到 `externalName` 字段的内容（例如，`foo.bar.example.com`），没有任何类型代理被创建。这种类型的 Service 对于一些特殊的服务发现用途非常有用。
- `Headless`: 这种类型的 Service 不会分配 ClusterIP，它会将 Service 的 DNS 记录解析为 Service 的 Endpoints 的集合。这种类型的 Service 通常用于 StatefulSet。

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
