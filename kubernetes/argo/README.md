Argo 项目包含四个主要的产品：

1. `Argo Workflows`：一个用于定义、运行和管理复杂的批处理和机器学习工作流的工具。

2. `Argo CD`：一个声明式的持续部署工具，用于将 Git 仓库中的应用配置自动同步到 Kubernetes 集群。

3. `Argo Rollouts`：一个提供高级部署策略（如蓝绿部署和金丝雀部署）的 Kubernetes 控制器。

4. `Argo Events`：一个用于定义和触发 Kubernetes 事件的事件驱动框架。

`Argo CD` 和 `Argo Workflows` 是最常用的。`Argo CD` 用于持续部署，使得开发者可以将更多的精力放在编写代码上，而不是管理部署。`Argo Workflows` 则用于运行复杂的工作流，如数据处理和机器学习任务。`Argo Rollouts` 和 `Argo Events` 的使用则取决于具体的需求，例如需要复杂的部署策略或事件驱动的自动化流程时。
