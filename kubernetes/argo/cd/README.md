## [部署方式](https://argo-cd.readthedocs.io/en/stable/operator-manual/installation/#installation)

![Architectural](https://argo-cd.readthedocs.io/en/stable/assets/argocd_architecture.png)

## Apps 管理

### 创建方式

- Web UI
- [YAML](https://argo-cd.readthedocs.io/en/stable/operator-manual/declarative-setup/)
- [Argo CLI](https://argo-cd.readthedocs.io/en/stable/user-guide/commands/argocd_app/)

### 参数

#### Sync Policy

- 手动
- [自动](https://argo-cd.readthedocs.io/en/stable/user-guide/auto_sync/)：当 Git 仓库中的 manifests 与集群中的实时状态不同时，ArgoCD 可以自动同步应用
  - 自动修剪(Automatic Pruning)：默认情况下，自动同步不会删除 Git 中未定义的资源
  - 自动自愈(Automatic Self-Healing)：默认情况下，集群状态改变不会触发自动同步
  - 允许空资源(Allow-Empty) (v1.8)：默认情况下，自动同步不允许应用没有目标资源

#### [Sync Options](https://argo-cd.readthedocs.io/en/stable/user-guide/sync-options/)

- `Validate=false`：在应用 Kubernetes 对象时禁用 kubectl 的验证，这对于使用 RawExtension 的 Kubernetes 类型（如 ServiceCatalog）来说是必要的，因为这些类型可能无法通过 kubectl 的默认验证。
- `Replace=true`： 使用 kubectl replace/create 代替 apply
- `PrunePropagationPolicy=(background|foreground|orphan)`：控制修剪时的删除传播策略，默认 background
- `ApplyOutOfSyncOnly=true`：只同步状态不一致的资源
- `CreateNamespace=true`：创建目标命名空间(如果不存在)
- `PruneLast=true`：资源修剪作为同步操作的最后一步
- `RespectIgnoreDifferences=true`：在同步期间忽略 `ignoreDifferences` 的配置
- `ServerSideApply=true`：启用 Kubernetes 服务端应用
- `Prune=false`：可以防止特定的 Kubernetes 对象在同步过程中被修剪（删除），即使这个对象在 Git 仓库的配置中已经不存在。这意味着即使你在 Git 仓库中删除了某个对象的配置，Argo CD 在同步时也不会删除集群中的这个对象。
- `SkipDryRunOnMissingResource=true`： 对于集群中缺失的自定义资源类型，跳过 dry-run
- `Delete=false`：防止在应用删除时清理某些资源
- `FailOnSharedResource=true`：当发现资源已被其他应用使用时失败

### App 定义支持的 manifests 类型

- [Kustomize 应用程序](https://argo-cd.readthedocs.io/en/stable/user-guide/kustomize/)
- [Helm](https://argo-cd.readthedocs.io/en/stable/user-guide/helm/)
- 一个包含 YAML/JSON/Jsonnet [文件的目录](https://argo-cd.readthedocs.io/en/stable/user-guide/directory/)，包括 Jsonnet。
  - [Jsonnet](https://argo-cd.readthedocs.io/en/stable/user-guide/jsonnet/)
- 任何配置为配置管理插件的自定义配置管理工具

### 状态

#### Sync Status

在 Argo CD 中，同步状态（Sync Status）表示集群的实际状态与 Git 仓库中定义的期望状态之间的差异。以下是每个状态的含义：

- `Unknown`: Argo CD 尚未确定应用的同步状态。这通常发生在 Argo CD 刚开始管理一个新应用，或者在 Argo CD 重新启动后。

- `Synced`: 集群的实际状态与 Git 仓库中定义的期望状态完全一致。这意味着所有的 Kubernetes 对象都已经被正确地创建或更新，没有任何剩余的更改需要应用。

- `OutOfSync`: 集群的实际状态与 Git 仓库中定义的期望状态存在差异。这可能是因为有新的更改需要应用，或者有一些 Kubernetes 对象被意外地修改或删除。在这种状态下，你通常需要执行一个同步操作来将集群的状态更新为期望的状态。

#### Health Status

在 Argo CD 中，健康状态（Health Status）表示应用的运行状况。以下是每个状态的含义：

- `Unknown`: Argo CD 无法确定应用的健康状态。这可能是因为应用的状态检查器无法处理应用的当前状态，或者应用的状态检查器尚未运行。

- `Progressing`: 应用正在向期望的状态转变。这通常意味着应用的一部分或全部正在被创建、更新或删除。

- `Suspended`: 应用已被暂停。这通常意味着应用的管理员已经手动将应用置于暂停状态，以阻止任何进一步的更改。

- `Healthy`: 应用正在正常运行，所有的 Kubernetes 对象都处于健康状态。

- `Degraded`: 应用的一部分或全部不健康。这可能是因为一些 Kubernetes 对象未能达到其期望的状态，或者应用的一部分或全部已经崩溃。

- `Missing`: 应用的一部分或全部丢失。这通常意味着一些 Kubernetes 对象已经被意外地删除。

## [Projects 管理](https://argo-cd.readthedocs.io/en/stable/user-guide/projects/)

ArgoCD 的 Project 主要提供以下功能：

1. 逻辑分组应用程序：

   - 当 ArgoCD 被多个团队使用时，Project 可以对应用进行逻辑分组。

2. 限制可部署的内容：

   - 可以限制可信的 Git 源代码仓库。
   - 可以限制允许部署到的目标集群和命名空间。
   - 可以限制允许部署的资源类型，如 RBAC、CRD、DaemonSet、NetworkPolicy 等。

3. 定义项目角色实现应用程序的 RBAC：

   - 可以将项目角色绑定到 OIDC 组或 JWT 令牌，以控制角色对应用的访问权限。

4. 继承全局项目配置：

   - 项目可以从全局项目继承一些配置，如资源黑白名单、同步窗口期、源仓库和目标集群等。

5. 支持项目作用域的代码仓库和集群：

   - 管理员可以允许开发人员在现有项目中自行添加代码仓库和集群，而无需管理员参与。

6. 限制应用只能部署到项目作用域的集群：
   - 可以配置项目只允许应用部署到该项目作用域内的集群。

### Project Roles

Project Roles 是 ArgoCD 项目中一个强大的功能，它允许为项目定义角色并授予这些角色不同的访问策略（policies），从而实现基于角色的访问控制（RBAC）。

主要特性包括：

1. 角色（Role）和策略（Policy）：

   - 每个项目可以定义多个角色。
   - 每个角色包含一个或多个策略，策略用于授予对项目应用程序的特定操作的权限。

2. 基于 JWT 令牌的认证：

   - ArgoCD 使用 JWT 令牌与角色关联，持有相应 JWT 令牌的用户即获得该角色的权限。
   - 可以为角色创建永久或临时 JWT 令牌。

3. 细粒度访问控制：

   - 策略可以授予角色针对特定应用的 get、sync、override、delete 等操作权限。
   - 也可以使用通配符授予对所有应用的操作权限。

4. 动态生效：
   - 修改角色策略后，关联该角色的 JWT 令牌权限会动态更新。

使用示例：

- 创建只读角色，允许 CI 工具同步应用但不能修改源和目标。
- 创建管理角色，允许一组开发人员管理特定应用。
- 临时 token 用于短期的应用部署和管理任务。

总之，Project Roles 为 ArgoCD 提供了细粒度的权限控制能力，使得不同角色可以被授予对应的最小权限，提高了系统安全性，同时也方便实现自动化流程与人工操作的融合。

## [App of Apps](https://argo-cd.readthedocs.io/en/stable/operator-manual/declarative-setup/#app-of-apps)

## 多集群

## [ApplicationSet](https://argo-cd.readthedocs.io/en/stable/operator-manual/applicationset/)


## 参考和引用

- https://github.com/argoproj/argocd-example-apps
