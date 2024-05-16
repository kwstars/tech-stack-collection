## [External Repository](https://github.com/kubernetes/kubernetes/tree/master/staging)

- `k8s.io/api`: 包含了所有 Kubernetes API 的 Go 语言定义。这个库提供了一组 Go 结构体，开发者可以使用这些结构体在他们的 Go 代码中创建、更新和查询 Kubernetes API 的对象。
- `k8s.io/apiextensions-apiserver`: 提供了注册 CustomResourceDefinitions 的 API，并作为 kube-apiserver 中的委托服务器提供 CustomResourceDefinitions 的实现。
- `k8s.io/apimachinery`: 提供了一组通用的工具和帮助函数，用于处理遵循 Kubernetes API 对象约定的 API 对象。
- `k8s.io/apiserver`: 提供了一个可扩展的 API 服务器框架，用于构建 Kubernetes API 服务器。这个库包含了创建 Kubernetes 聚合服务器的代码，包括委托认证和授权、与 kubectl 兼容的发现信息、可选的准入链和版本化类型。其首个使用者是 `k8s.io/kubernetes`、`k8s.io/kube-aggregator` 和 `github.com/kubernetes-incubator/service-catalog`。
- `k8s.io/cli-runtime`: 提供了一组用于创建 kubectl 命令和插件的帮助函数。这个库是客户端与 Kubernetes API 基础设施交互的共享依赖，可以保持与 kubectl 兼容的行为。其首个使用者是 `k8s.io/kubectl`。
- `k8s.io/client-go`: 用于与 Kubernetes 集群进行交互，包括访问 Kubernetes API、发现 API 服务器支持的 API、执行任意 Kubernetes API 对象的通用操作等。
- `k8s.io/code-generator`: 用于生成 Go 语言代码的工具，它可以在自定义资源定义（CustomResourceDefinition）的上下文中用于构建本地的、版本化的客户端、通知器（informers）和其他帮助函数，或者在用户提供的 API 服务器的上下文中用于构建内部和版本化类型之间的转换、默认值设定项、protobuf 编解码器、内部和版本化的客户端和通知器。

## Group-Version-Resource

在 Kubernetes 中，Group-Version-Resource（GVR）是用来唯一标识 API 资源的一种方式。

- **Group**：表示 API 组，它是一组相关的 API 资源的集合。例如，所有的 Pod、Service、Deployment 等核心资源都属于 "" 组（核心组），而所有的 Deployment、StatefulSet、DaemonSet 等资源都属于 "apps" 组。
- **Version**：表示 API 的版本。Kubernetes 支持 API 版本控制，以便在不破坏现有用户的情况下引入新的 API 变更。例如，v1、v1beta1 等。
- **Resource**：表示 API 资源类型。在 Kubernetes 中，资源是可以通过 API 操作的实体，如 Pod、Node、Service 等。

[Kubernetes API](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.30/#api-overview) 主要分为两类：核心（Core）API 和扩展（Extensions）API。

1. **核心 API**：核心 API 是 Kubernetes 的基础 API，它包括了 Kubernetes 的核心对象，如 Pod、Service、Volume、Namespace 等。核心 API 的访问路径格式为：

   - `/api/v1/<plural_name>`：访问集群范围内的核心资源。例如，`/api/v1/pods` 用于访问集群中的所有 Pod。
   - `/api/v1/namespaces/<ns>/<plural_name>`：访问特定命名空间内的核心资源。例如，`/api/v1/namespaces/default/pods` 用于访问 default 命名空间中的所有 Pod。

2. **扩展 API**：扩展 API 是 Kubernetes 的扩展功能，它包括了 Deployment、DaemonSet、StatefulSet、Ingress 等。扩展 API 的访问路径格式为：

   - `/apis/<group>/<version>/<plural_name>`：访问集群范围内的扩展资源。例如，`/apis/apps/v1/deployments` 用于访问集群中的所有 Deployment。
   - `/apis/<group>/<version>/namespaces/<ns>/<plural_name>`：访问特定命名空间内的扩展资源。例如，`/apis/apps/v1/namespaces/default/deployments` 用于访问 default 命名空间中的所有 Deployment。

在这里，`<group>` 是 API 组，`<version>` 是 API 版本，`<plural_name>` 是资源类型的复数形式，`<ns>` 是命名空间。

## [The Client-go Library](https://github.com/kubernetes/client-go)

## [Custom Resource Definitions(CRDs)](https://kubernetes.io/docs/concepts/extend-kubernetes/api-extension/custom-resources/)

CRDs 是 Kubernetes 提供的一种机制，允许在 Kubernetes API 中定义新的资源类型。这些新的资源类型被称为 Custom Resources。一旦定义了 CRD，就可以像操作内置的资源类型（如 Pod、Service 等）一样，通过 Kubernetes API 操作这些自定义资源。

可以使用 `client-go` 库中的动态客户端和 `Unstructured` 类型来操作自定义资源。`Unstructured` 类型可以表示任何没有预先定义结构的 Kubernetes 资源，包括自定义资源。动态客户端可以在运行时处理任何类型的 Kubernetes 资源，包括自定义资源。这种方式的优点是灵活，不需要预先知道资源的结构，也不需要每次资源的定义改变时重新生成代码。但是，这种方式不是类型安全的，可能会在运行时遇到错误。

## [Controllers](https://kubernetes.io/docs/concepts/architecture/controller/)

Controllers 是 Kubernetes 中的一种设计模式，它们是一种运行在 Kubernetes 集群中的、用于观察和管理 Kubernetes 资源的软件组件。Controllers 通过监听资源的状态变化，并根据当前状态和期望状态之间的差异来执行相应的操作，以达到将资源的当前状态调整为期望状态的目标。Controllers 可以用来管理内置的资源类型，也可以用来管理通过 CRDs 定义的自定义资源。

- [Writing Controllers](https://github.com/kubernetes/community/blob/master/contributors/devel/sig-api-machinery/controllers.md)
- [Kubernetes Sample Controller](https://github.com/kubernetes/sample-controller)

### controller-runtime

`controller-runtime` 是一个由 Kubernetes SIGs 提供的库，它为构建 Kubernetes 控制器提供了工具和库。控制器是 Kubernetes 的核心组件，它们负责管理资源的生命周期，确保资源的状态与用户的期望一致。

`controller-runtime` 提供了一些更高级的抽象和便利的工具，使得开发者可以更容易地创建和管理 Kubernetes 控制器。例如，`controller-runtime` 提供了一个通用的控制器接口，开发者只需要实现这个接口，就可以创建一个新的控制器。

`controller-runtime` 在底层使用了 `k8s.io/client-go` 库来与 Kubernetes API 服务器进行通信。所有的 API 操作，如获取、创建、更新和删除资源，都是通过 `client-go` 完成的。`controller-runtime` 的 `Client` 接口实际上是对 `client-go` 的 `Interface` 接口的一个封装，它提供了一些额外的功能，如缓存和最终一致性。

## [Operator](https://kubernetes.io/docs/concepts/extend-kubernetes/operator/)

Operators 是一种特殊的 Controller，它们用于管理特定应用或服务的生命周期。Operators 通常会使用 CRDs 来定义它们管理的资源类型，然后在 Controller 的逻辑中实现这些资源的管理策略。例如，一个数据库 Operator 可能会定义一个表示数据库实例的 CRD，然后在 Controller 中实现创建、更新、备份、恢复等数据库操作。

[创建 Kubernetes Operator](https://kubernetes.io/docs/concepts/extend-kubernetes/operator/#writing-operator) 最常用的 Kubernetes Operator 创建工具通常包括：

1. **[kubebuilder](https://github.com/kubernetes-sigs/kubebuilder)**：这是一个由 Kubernetes 社区维护的开源项目，它提供了一套工具来帮助开发者创建、构建和部署 CRDs 和 Controllers。kubebuilder 提供了丰富的特性和良好的文档，是创建 Kubernetes Operator 的主流工具。如 [cert-manager](https://github.com/jetstack/cert-manager)，[KubeVirt](https://github.com/kubevirt/kubevirt)，[Gatekeeper](https://github.com/open-policy-agent/gatekeeper)，[Knative Serving](https://github.com/knative/serving) 等。

2. **Operator Framework**：这是一个由 Red Hat 维护的开源项目，它提供了一套工具来帮助开发者快速创建、构建和部署 Operators。Operator Framework 包括 Operator SDK、Operator Lifecycle Manager 和 OperatorHub.io 等组件，提供了一整套的 Operator 开发和管理解决方案。如 [Prometheus Operator](https://github.com/prometheus-operator/prometheus-operator), [Jaeger Operator](https://github.com/jaegertracing/jaeger-operator), [Strimzi](https://github.com/strimzi/strimzi-kafka-operator) 等。

3. **KUDO (Kubernetes Universal Declarative Operator)**：这是一个用于创建和管理 Kubernetes Operator 的框架，它使用 Go 语言。KUDO 允许使用声明式的方式来定义 Operator 的行为，无需编写大量的代码。[使用 KUDO 构建的 Kubernetes Operator 集合](https://github.com/kudobuilder/operators)。

## Admission Controllers

在 Kubernetes 中，Admission 控制器是 API server 的一部分，它们在持久化对象之前拦截请求，可以对请求进行修改或拒绝。Admission 控制器分为两种类型：Mutating Admission 和 Validating Admission。

**Mutating Admission**：在对象被持久化之前，但在验证之后运行。它们可以修改对象，例如添加、修改或删除对象的字段。这使得它们可以实现默认值、设置字段的值等功能。例如，Pod 的默认资源限制就是通过 Mutating Admission 控制器实现的。

**Validating Admission**：在对象被持久化之前，但在 Mutating Admission 控制器之后运行。它们可以拒绝无效或不符合策略的请求。这使得它们可以实现策略检查、验证字段的值等功能。例如，PodSecurityPolicy 就是通过 Validating Admission 控制器实现的。

在 Kubernetes 中，Admission 控制器的执行顺序是：首先执行所有的 Mutating Admission 控制器，然后更新对象的状态，然后执行所有的 Validating Admission 控制器。如果任何一个 Admission 控制器拒绝了请求，那么整个请求就会被拒绝，对象不会被持久化。

![Admission Controllers](https://kubernetes.io/images/blog/2019-03-21-a-guide-to-kubernetes-admission-controllers/admission-controller-phases.png)

### Webhook

Admission Controllers 可以分为官方的和自定义的。

**[官方的 Admission Controllers](https://kubernetes.io/docs/reference/access-authn-authz/admission-controllers/#what-does-each-admission-controller-do)**：Kubernetes 提供了一些内置的 Admission Controllers，例如 NamespaceLifecycle、LimitRanger、ServiceAccount、DefaultStorageClass 等。这些 Admission Controllers 已经被 Kubernetes 集成在内，可以直接在 API server 启动时通过 `--enable-admission-plugins` 参数启用。

**[Dynamic Admission Control](https://kubernetes.io/docs/reference/access-authn-authz/extensible-admission-controllers/)**：除了内置的 Admission Controllers，Kubernetes 还允许用户自定义 Admission Controllers。自定义的 Admission Controllers 可以是 MutatingAdmissionWebhook 或 ValidatingAdmissionWebhook，它们可以调用外部的 HTTP(S) 服务来修改或验证对象。这使得用户可以根据自己的需求来实现各种策略和功能。

自定义的 Admission Controllers 需要编写代码并部署为一个独立的服务，然后在 API server 中配置 Webhook 来调用这个服务。这比较复杂，但提供了很大的灵活性。

Istio 使用 mutating webhooks 来自动将 Envoy sidecar 容器注入到 Pod 中。当你为 Kubernetes namespace 打上特定的标签后，Istio 的 mutating webhook 就会监听这个 namespace 下的 Pod 创建事件，然后自动修改 Pod 的定义，将 Envoy sidecar 容器添加到 Pod 中。这种[Automatically injecting Envoy sidecar](https://istio.io/latest/docs/setup/additional-setup/sidecar-injection/#automatic-sidecar-injection)的方式大大简化了 Envoy sidecar 的部署，使得用户可以更容易地使用 Istio 的服务网格功能。

[A Simple Kubernetes Admission Webhook](https://slack.engineering/simple-kubernetes-webhook/)

## 参考和引用

- [OpenAPI Specification v2](https://github.com/kubernetes/kubernetes/tree/master/api/openapi-spec)
- [OpenAPI Specification v3 (Kubernetes v1.24)](https://github.com/kubernetes/kubernetes/tree/master/api/openapi-spec/v3)
- [Kubernetes Programming with Go](https://github.com/Apress/Kubernetes-Programming-with-Go-by-Philippe-Martin)
- [The Kubernetes Operator Framework Book](https://github.com/PacktPublishing/The-Kubernetes-Operator-Framework-Book)
- [Programming Kubernetes](https://github.com/programming-kubernetes)
