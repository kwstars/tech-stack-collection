## 架构

![ing](https://static.apiseven.com/uploads/2023/02/23/KCin3Lzq_220592786-0d6d9605-4fbe-43d4-9f7e-798b9b072af9.png)

这是一些在 ETCD 中常见的术语及其描述：

- **Raft**：Raft 算法，是 ETCD 实现一致性的核心。ETCD 有一个名为 etcd-raft 的模块来实现这个算法。
- **Follower**：在 Raft 算法中的从属节点，如果竞选 Leader 失败，就会成为 Follower。
- **Leader**：在 Raft 算法中的领导节点，用于处理数据提交。Leader 节点负责协调整个集群。
- **Candidate**：候选节点。当 Follower 节点在一定时间内没有接收到 Leader 节点的消息，就会转变为 Candidate。
- **Node**：Raft 状态机的实例。在 Raft 算法中，会涉及到多个这样的节点。
- **Member**：ETCD 实例，管理着对应的 Node 节点。Member 可以处理客户端的请求。
- **Peer**：同一个集群中的另一个 Member。也就是集群中的其他成员。
- **Cluster**：ETCD 集群，由多个 ETCD Member 组成。
- **Lease**：租期。在 ETCD 中，可以为键值对设置租期，租期过期后，对应的键值对会被删除。
- **Watch**：监测机制。在 ETCD 中，可以设置 Watch 来监控键值对的变化。
- **Term**：任期。在 Raft 算法中，任期是指某个节点成为 Leader 到下一次竞选的时间。
- **WAL**：预写式日志。这是 ETCD 用于持久化存储的日志格式。
- **Client**：客户端。在 ETCD 中，客户端是指向 ETCD 发起请求的实体。

### [部署模式](https://etcd.io/docs/v3.5/op-guide/clustering/)

ETCD 提供了多种部署模式，包括静态部署、etcd 发现服务部署和 DNS 发现部署。

1. **静态部署**：在这种模式下，每个集群成员需要知道其他成员的信息。这种方式适合于集群成员的 IP 地址在部署前就已知的情况。

2. **etcd 发现服务部署**：在许多情况下，集群成员的 IP 地址可能在部署前是未知的。在这种情况下，可以使用 etcd 的发现服务来引导集群的启动。etcd 发现服务是一个简单的 HTTP(S) 服务，它可以帮助 etcd 集群的成员发现彼此。

3. **DNS 发现部署**：这种方式使用 DNS 记录来发现集群成员。这种方式适合于使用 DNS 服务管理集群成员的情况。

### 应用场景

ETCD 的主要应用场景包括：

- **键值对存储**：ETCD 是一个用于存储键值对的组件，这是 ETCD 最基本的功能。所有其他的应用场景都建立在 ETCD 的可靠存储基础之上。

- **服务注册与发现**：在微服务架构中，服务需要能够找到其他服务的位置，这就需要一个服务注册与发现的机制。ETCD 基于 Raft 算法，能够在分布式场景中保证一致性，因此非常适合用于服务注册与发现。

- **消息发布与订阅**：ETCD 支持 Watch 机制，可以监控键值对的变化，因此可以用于实现消息发布与订阅。

- **分布式锁**：在分布式系统中，有时需要确保某个操作在同一时间只能被一个节点执行，这就需要一个分布式锁。ETCD 基于 Raft 算法，可以保证存储到 ETCD 集群中的值是全局一致的，因此可以基于 ETCD 实现分布式锁。

## 参考和引用

- https://www.slideshare.net/slideshow/unveiling-etcd-architecture-and-source-code-deep-dive/259587952
- http://play.etcd.io/install
