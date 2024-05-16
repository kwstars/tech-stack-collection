## 模块

## ![img](https://pek3b.qingstor.com/kubesphere-community/images/kubernetes-client-go.png)

- **[Clientset](https://github.com/kubernetes/client-go/blob/62f959700d559dd8a33c1f692cb34219cfef930f/kubernetes/clientset.go#L138-L193)**：提供了访问 Kubernetes RESTful API 的接口。Clientset 将 Kubernetes API 分为多个 group，并为每个 group 提供一个接口。每个 group 又包含多个版本的 API。例如，可以使用 Clientset 的 CoreV1() 方法来访问 core group 的 v1 版本 API，然后调用 Pods() 方法来操作 Pod 资源。
- **[Reflector](https://github.com/kubernetes/client-go/blob/62f959700d559dd8a33c1f692cb34219cfef930f/tools/cache/reflector.go#L58-L122)**：监视 Kubernetes API server 上的特定资源，并将这些资源的更改反映到本地的存储（通常是一个缓存）。这样，客户端可以通过访问本地存储而不是直接请求 API server 来获取资源的最新状态，从而减少了网络请求和 API server 的负载。
- **[DeltaFIFO](https://github.com/kubernetes/client-go/blob/62f959700d559dd8a33c1f692cb34219cfef930f/tools/cache/delta_fifo.go#L60-L139)**：是一个队列，用于处理和存储 Kubernetes 资源对象的更改（称为 "deltas"）。这些更改可以是添加、更新或删除操作。
- **[Informer](https://github.com/kubernetes/client-go/blob/62f959700d559dd8a33c1f692cb34219cfef930f/tools/cache/controller.go#L394-L406)**：监听 Kubernetes API Server 上的资源变化，维护一个本地的资源缓存，并触发相应的事件处理器来响应资源的添加、更新和删除事件。
- **[Indexer](https://github.com/kubernetes/client-go/blob/62f959700d559dd8a33c1f692cb34219cfef930f/tools/cache/index.go#L26-L55)**：是一个接口，它扩展了存储器（Store）接口，提供了通过索引获取对象的能力。这使得用户可以通过多个字段（而不仅仅是对象的 ID）来查询对象，从而提高查询效率。
- **[workqueue](https://github.com/kubernetes/client-go/tree/kubernetes-1.30.1/util/workqueue)**：`workqueue` 是 Kubernetes 的一个包，它提供了一种在多个 goroutine 之间安全地分发工作的机制。`workqueue` 提供了几种队列类型，包括基本队列、延迟队列、速率限制队列和优先级队列。这些队列都实现了 `workqueue.Interface` 接口，该接口定义了添加、获取和删除队列元素的方法。`workqueue` 还提供了一种机制来标记正在处理的元素，当处理失败时，这些元素可以被重新添加到队列中。这使得 `workqueue` 非常适合用于实现重试逻辑。
- **Worker**：worker 线程是用于处理工作队列中的项目的并发线程。每个 worker 线程会连续调用 `processNextItem`( 函数，该函数会从队列中获取下一个项目，然后调用业务逻辑处理函数（例如 `syncToStdout`）来处理该项目。如果处理过程中出现错误，worker 线程会将项目重新放入队列，以便稍后重试。这种机制确保了即使在处理某些项目时出现错误，worker 线程也能继续处理队列中的其他项目。在 `Controller.Run`方法中，会启动指定数量的 worker 线程，并在接收到停止信号时停止这些线程。这种设计使得 worker 线程的数量可以根据需要进行调整，以便在处理大量项目时提高处理速度，或者在资源有限的情况下限制处理速度。

## 连接集群的方式

client-go 提供了两种主要的方式来连接到 Kubernetes 集群：

1. **[使用 kubeconfig 文件](https://github.com/kubernetes/client-go/blob/kubernetes-1.30.1/examples/out-of-cluster-client-configuration)**：这是最常见的方式，特别是在本地开发环境中。kubeconfig 文件包含了连接到集群所需的所有信息，包括 API 服务器的地址，认证信息，以及默认的命名空间等。可以使用 `clientcmd.BuildConfigFromFlags` 函数来从 kubeconfig 文件创建一个新的配置。

2. **[使用 InClusterConfig](https://github.com/kubernetes/client-go/tree/kubernetes-1.30.1/examples/in-cluster-client-configuration)**：这种方式主要用于在集群内部运行的 Pod。当应用部署在 Kubernetes 集群内部时，它可以直接使用 Service Account 提供的凭据来连接到 API 服务器。可以使用 `rest.InClusterConfig` 函数来获取这个配置。

## Client 类型

1. `Clientset（Typed）`：使用预生成的 API 对象与 Kubernetes API 服务器进行交互。这些客户端为每个 Kubernetes API 版本和组提供了一组 Go 语言的类型，这些类型可以用于创建、读取、更新、删除和观察 Kubernetes 资源。例如 `CoreV1()`, `AppsV1()` 等。这些接口提供了用于操作 Kubernetes 资源（如 Pods，Services，Deployments 等）的方法。

2. `DiscoveryClient`：Discovery 客户端用于发现 API 服务器支持的所有 API 版本和资源。这对于动态客户端来说是非常有用的，因为它可以在运行时确定服务器支持的资源类型。

3. `Dynamic`：Dynamic 客户端使用 `unstructured.Unstructured` 类型来表示所有从 API 服务器接收到的对象。这种类型使用嵌套的 `map[string]interface{}` 值来创建一个内部结构，这个结构与从服务器接收到的 REST 负载非常相似。

4. `RESTClient` 是一个更底层的客户端，它直接发送和接收 HTTP 请求和响应。`RESTClient` 提供了对 Kubernetes API 的基本 RESTful 操作（如 GET，POST，PUT，DELETE）的支持。`Clientset` 和 `DiscoveryClient`都是基于 `RESTClient` 构建的。例如，可能需要发送自定义的 HTTP 请求，或者处理不在 `Clientset` 中的 Kubernetes API。`RESTClient` 提供了对 Kubernetes API 的基本 RESTful 操作（如 GET，POST，PUT，DELETE）的支持。

## Leader Election

在 Kubernetes 中，client-go 的 Leader Election 主要用于以下场景：

1. **Kubernetes 控制器**：Kubernetes 控制器，如 Deployment 控制器、ReplicaSet 控制器等，都运行在 Kubernetes 控制平面上。为了提高可用性，控制平面通常会在多个节点上运行多个实例。然而，对于每种类型的控制器，我们通常只希望一个实例在任何时候都能够进行重要的决策（如调度 Pod）。因此，这些控制器会使用 Leader Election 来选出一个领导者。

2. **Kubernetes 调度器**：Kubernetes 调度器也使用了 Leader Election。这样，如果主调度器实例发生故障，其他调度器实例可以接管并继续调度新的 Pods。

3. **自定义控制器和操作员**：如果正在编写自己的自定义控制器或 Operator，并且希望在多个实例之间提供高可用性，那么可能也需要使用 Leader Election。这样，可以确保在任何时候只有一个实例在做决策或修改集群状态。

4. **其他需要协调多个实例的应用**：任何需要在多个实例之间协调或同步的应用都可以使用 Leader Election。例如，可能有一个需要在集群中的多个实例之间共享的任务，但是希望在任何时候只有一个实例在执行这个任务。通过使用 client-go 的 Leader Election 功能，可以确保在任何时候只有一个被选为领导者的实例在执行任务，而其他实例则在领导者失败时准备接管任务。

## Fake Client

Fake client 是 client-go 提供的一个模拟客户端，用于在单元测试中模拟与 Kubernetes API 服务器的交互。使用 Fake client，可以在不需要实际 Kubernetes 集群的情况下测试代码。

Fake client 提供了与真实 Kubernetes 客户端相同的接口，但是所有的操作都是在内存中进行的，而不是在真实的 Kubernetes 集群中。这意味着可以使用 Fake client 来创建、获取、更新和删除 Kubernetes 资源，就像使用真实的 Kubernetes 客户端一样。

在测试代码中，使用 `fake.NewSimpleClientset()` 创建了一个新的 Fake client。然后，添加了一个 watch reactor，这是一个函数，它会在每次调用 watch 操作时被调用。在这个函数中，关闭了 `watcherStarted` 通道，这表示 watch 操作已经开始。

然后，创建了一个 informer，它会将添加的 pods 写入一个通道。这是一个常见的模式，用于在添加新的 Kubernetes 资源时接收通知。

## 参考和引用

- [Kubernetes client-go 源码分析](https://kubesphere.io/zh/blogs/kubernetes-client-go-workqueue/)
