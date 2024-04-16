## 常用命令

```bash
# helm repo add [NAME] [URL] [flags]
# 将 Longhorn chart 仓库添加到你的 Helm 仓库中
helm repo add longhorn https://charts.longhorn.io

# 列出所有已添加的 Helm 仓库
helm repo list

# 更新 Helm 仓库
helm repo update

# helm show chart [CHART] [flags]
# 显示 Traefik chart 的详细信息
# [CHART] 参数通常由两部分组成：[REPO]/[NAME]。[REPO] 是 Helm 仓库的名称，这是你在添加 Helm 仓库时指定的名称。[NAME] 是 chart 在该仓库中的名称。
helm show chart traefik/traefik

# 显示 Traefik chart 的所有信息
helm show all traefik/traefik

# 显示 Traefik chart 的可以定制的参数
helm show values traefik/traefik

# 获取名为 traefik 的 Helm 发布的当前值
helm get values traefik

# 列出所有命名空间中的 Helm 发布，其中的 `NAME` 列显示的就是 release 的名称。
helm ls -A

# helm install [NAME] [CHART] [flags]
# helm upgrade [RELEASE] [CHART] [flags]

# 使用指定的配置文件更新或安装名为 longhorn 的 Helm Chart，并指定版本为 1.6.1，部署在 infra 命名空间中
helm upgrade --install longhorn longhorn/longhorn --namespace infra --create-namespace --version 1.6.1 -f ./helm/longhorn.yaml

# helm uninstall RELEASE_NAME [...] [flags]
# 卸载名为 prometheus 的 Helm 发布
helm uninstall prometheus

# 卸载名为 prometheus 的 Helm 发布，但保留其历史记录，日志记录保存在 kubectl get secret -n monitoring
helm uninstall prometheus --keep-history -n monitoring

# 查看名为 prometheus 的 Helm 发布在 monitoring 命名空间中的历史版本
helm history -n monitoring prometheus

# helm rollback <RELEASE> [REVISION] [flags]
# 将名为 prometheus 的 Helm 发布在 monitoring 命名空间中回滚到版本 1
helm rollback prometheus 1 -n monitoring

# 列出所有命名空间中的 Helm 发布，包括已卸载的
helm ls -A -a

# helm pull|fetch [chart URL | repo/chartname] [...] [flags]
# 从 Prometheus 社区的 Helm 仓库下载 kube-prometheus-stack chart
helm pull https://prometheus-community.github.io/helm-charts prometheus-community/kube-prometheus-stack

# helm template [NAME] [CHART] [flags]
# 使用指定的配置文件生成名为 longhorn 的 Helm 发布的 Kubernetes 清单，但不实际部署
helm template longhorn longhorn/longhorn -f values.yaml

# helm get manifest RELEASE_NAME [flags]
# 使用 Helm 获取 Traefik 在 kube-system 命名空间中的 manifest
helm get manifest traefik -n kube-system
```

## `--set` 定制安装

当你安装 Helm charts 时，你可以通过两种方式传递配置数据，让安装更符合你的需求：

1. 使用 `--values` 参数（或者 `-f` 简写）：通过指定一个 YAML 文件来覆盖默认的 values，这个文件中可以指定多个值，最终会使用文件中最后出现的值。
2. 使用 `--set` 参数：直接在命令行上指定要覆盖的配置。

如果你同时使用这两个参数，那么 `--values`（或 `-f`）的值会被合并到具有更高优先级的 `--set` 中。使用 `--set` 指定的值会被持久化在 ConfigMap 中，你可以通过运行 `helm get values <release-name>` 命令来查看已经设置的值。你也可以通过运行 `helm upgrade` 并指定 `--reset` 参数来清除已设置的值。

`--set` 选项可以接受零个或多个名/值对。最简单的用法是 `--set name=value`，这相当于在 YAML 文件中写入：

```yaml
name: value
```

你也可以用逗号分隔多个值，比如 `--set a=b,c=d`，相当于在 YAML 文件中写入：

```yaml
a: b
c: d
```

`--set` 还支持更复杂的表达式，比如 `--set outer.inner=value`，对应的 YAML 结构为：

```yaml
outer:
  inner: value
```

对于列表数组，可以使用大括号来包裹，比如 `--set name={a, b, c}`，对应的 YAML 结构为：

```yaml
name:
  - a
  - b
  - c
```

从 Helm 2.5.0 开始，你还可以使用数组索引语法来访问列表中的某个项，比如 `--set servers[0].port=80`，对应的 YAML 结构为：

```yaml
servers:
  - port: 80
```

你也可以一次设置多个值，比如 `--set servers[0].port=80,servers[0].host=example`，对应的 YAML 结构为：

```yaml
servers:
  - port: 80
    host: example
```

有时候你可能需要在 `--set` 选项中使用特殊字符，这时可以使用反斜杠来转义字符，比如 `--set name=value1\,value2`，对应的 YAML 结构为：

```yaml
name: "value1,value2"
```

同样地，你也可以转义点号（.）。这在 chart 模板中使用 `toYaml` 函数来解析 annotations、labels 以及 node selectors 等时非常有用。比如 `--set nodeSelector."kubernetes\.io/role"=master`，对应的 YAML 结构为：

```yaml
nodeSelector:
  kubernetes.io/role: master
```

## Chart 文件目录结构

```bash
mychart                    # Helm chart 的根目录，通常以 chart 的名称命名
  ├── charts               # 存放 chart 依赖的其他 chart 的目录
  │   └── mydependency     # 依赖的 chart 的目录
  │       ├── charts       # 依赖的 chart 的依赖 chart 目录
  │       ├── Chart.yaml   # 依赖的 chart 的元数据文件
  │       ├── templates    # 依赖的 chart 的模板文件目录
  │       └── values.yaml  # 依赖的 chart 的默认配置值文件
  ├── Chart.yaml          # 描述 chart 的元数据的文件，如版本、描述等
  ├── crds                # 存放 Custom Resource Definitions 的目录
  │   └── my-crd.yaml     # Custom Resource Definition 文件
  ├── templates           # 存放 Kubernetes 资源定义模板的目录
  │   ├── deployment.yaml # Deployment 资源的模板文件
  │   ├── _helpers.tpl    # 存放模板帮助函数的文件
  │   ├── hpa.yaml        # Horizontal Pod Autoscaler 资源的模板文件
  │   ├── ingress.yaml    # Ingress 资源的模板文件
  │   ├── NOTES.txt       # 在 helm install 命令执行后显示的信息
  │   ├── serviceaccount.yaml # ServiceAccount 资源的模板文件
  │   ├── service.yaml    # Service 资源的模板文件
  │   └── tests           # 存放 Helm 测试定义的目录
  │       └── test-connection.yaml # Helm 测试定义的文件
  └── values.yaml         # 默认的配置值文件，这些值会被模板文件使用
```

## Values

### [内置的 Values](https://helm.sh/docs/chart_template_guide/builtin_objects/)

Helm 有一些预定义的对象和值，这些可以在模板中使用。以下是一些主要的预定义值：

- `.Release`: 在 Helm 运行时自动提供的。这些值包括 Helm release 的详细信息，如名称、命名空间、是否为升级操作等。在你的示例中，`{{ .Release.Name }}` 将被替换为当前 Helm release 的名称。例如，如果你使用 `helm install my-release my-chart` 命令安装 chart，那么 `{{ .Release.Name }}` 将被替换为 `my-release`。这个对象描述了 release 本身。它有几个预定义的值，包括：

  - `.Release.Name`: release 的名称。
  - `.Release.Namespace`: release 被安装的命名空间。
  - `.Release.IsUpgrade`: 这是一个布尔值，表示当前操作是否是一个升级操作。
  - `.Release.IsInstall`: 这是一个布尔值，表示当前操作是否是一个安装操作。
  - `.Release.Revision`: 当前 release 的修订版本号。

- `.Values`: 这个对象包含了 `values.yaml` 文件中定义的值。

- `.Chart`: 来自于 Helm chart 的 `Chart.yaml` 文件。这个文件包含了 chart 的元数据，例如 chart 的名称、版本、描述等。它有几个预定义的值，包括：

  - `.Chart.Name`: chart 的名称。
  - `.Chart.Version`: chart 的版本。
  - `.Chart.AppVersion`: chart 的 app 版本。

- `.Files`: 来自 Helm chart 的文件系统。这个对象提供了一种方法，可以让你在模板中访问 chart 文件夹中的非模板文件。例如，如果你的 chart 文件夹中有一个名为 `config.ini` 的文件，你可以在模板中使用 `{{ .Files.Get "config.ini" }}` 来获取该文件的内容。

- `.Capabilities`: 来自 Helm 运行时环境，它提供了关于 Kubernetes 集群的信息。这些信息包括 Kubernetes 的版本、API 版本、Helm 版本等。例如，`.Capabilities.KubeVersion` 提供了 Kubernetes 的版本信息，`.Capabilities.APIVersions.Has "batch/v1"` 可以用来检查 Kubernetes 集群是否支持 `batch/v1` API 版本。

- `.Template`: 来自 Helm 的运行时环境。这个对象包含了关于当前正在执行的模板的信息。例如，`.Template.Name` 提供了当前模板的名称（包括路径），`.Template.BasePath` 提供了当前 chart 的模板目录的路径。

### [全局的 Values](https://helm.sh/docs/chart_template_guide/subcharts_and_globals/#global-chart-values)

1. 全局值是可以从任何图表或子图表通过完全相同的名称访问的值。全局值需要明确声明，不能将现有的非全局值当作全局值使用。
2. Values 数据类型有一个名为 Values.global 的保留部分，可以在其中设置全局值。例如，在 `mychart/values.yaml` 文件中设置一个全局值。
3. 由于全局值的工作方式，`mychart/templates/configmap.yaml` 和 `mysubchart/templates/configmap.yaml` 都应该能够以 `{{ .Values.global.salad }}` 的形式访问该值。
4. 如果我们进行干运行安装，我们将在两个输出中看到相同的值。
5. 全局值对于传递这样的信息很有用，尽管需要一些规划来确保正确的模板被配置为使用全局值。
6. 父图表和子图表可以共享模板。任何图表中定义的块都可以供其他图表使用。
7. 我们可以定义一个简单的模板，如 `{{- define "labels" }}from: mychart{{ end }}`。请记住，模板上的标签是全局共享的。因此，标签图表可以从任何其他图表中包含。
8. 虽然图表开发者可以在 `include` 和 `template` 之间选择，但使用 `include` 的一个优点是 `include` 可以动态引用模板：`{{ include $mytemplate }}`。上述将解引用 `$mytemplate`。相比之下，`template` 函数只接受字符串字面量。
9. 避免使用块。Go 模板语言提供了一个 `block` 关键字，允许开发者提供一个默认实现，后续可以覆盖。在 Helm 图表中，块不是最好的覆盖工具，因为如果提供了同一块的多个实现，选择哪一个是不可预测的。建议使用 `include`。

## [Custom Resource Definitions](https://helm.sh/docs/chart_best_practices/custom_resource_definitions/)

以下是关于 Helm 中自定义资源定义（CRDs）的一些关键点：

1. CRD 有两个部分：CRD 的声明（`kind: CustomResourceDefinition` 的 YAML 文件）和使用 CRD 的资源（例如，如果 CRD 定义了 `foo.example.com/v1`，那么任何 `apiVersion: example.com/v1` 和 `kind: Foo` 的资源都是使用该 CRD 的资源）。

2. 在使用 CRD 的资源之前，必须先安装 CRD 的声明。这是因为 Kubernetes 需要一些时间来注册 CRD。

3. Helm 3 提供了一个名为 `crds` 的特殊目录，你可以在这个目录中放置你的 CRDs。这些 CRDs 不会被模板化，但在运行 helm 安装 chart 时会默认安装。如果 CRD 已经存在，它将被跳过并给出警告。如果你希望跳过 CRD 的安装步骤，你可以传递 `--skip-crds` 标志。

4. 目前，Helm 不支持升级或删除 CRDs。这是经过社区讨论后的明确决定，因为这可能导致数据意外丢失。此外，目前社区对于如何处理 CRDs 及其生命周期还没有达成共识。随着这个问题的发展，Helm 将添加对这些用例的支持。

5. Helm 的 `--dry-run` 标志目前不支持 CRDs。这是因为 "Dry Run" 的目的是验证 chart 的输出是否可以在发送到服务器后正常工作。但是，CRDs 实际上是修改了服务器的行为。Helm 无法在 dry run 中安装 CRD，因此 discovery 客户端将不知道该自定义资源（CR），并且验证将失败。

6. 另一种处理 CRD 的方法是将 CRD 定义放在一个 chart 中，然后将使用该 CRD 的任何资源放在另一个 chart 中。在这种方法中，每个 chart 必须单独安装。然而，这种工作流可能对具有集群管理员访问权限的集群运维人员更有用。

## Chart 示例

```bash
$ helm fetch  https://traefik.github.io/charts traefik/traefik
$ tar xf traefik-27.0.2.tgz
$ tree traefik
traefik
├── Changelog.md
├── Chart.yaml
├── crds
│   ├── traefik.containo.us_ingressroutes.yaml
│   ├── traefik.containo.us_ingressroutetcps.yaml
│   ├── traefik.containo.us_ingressrouteudps.yaml
│   ├── traefik.containo.us_middlewares.yaml
│   ├── traefik.containo.us_middlewaretcps.yaml
│   ├── traefik.containo.us_serverstransports.yaml
│   ├── traefik.containo.us_tlsoptions.yaml
│   ├── traefik.containo.us_tlsstores.yaml
│   ├── traefik.containo.us_traefikservices.yaml
│   ├── traefik.io_ingressroutes.yaml
│   ├── traefik.io_ingressroutetcps.yaml
│   ├── traefik.io_ingressrouteudps.yaml
│   ├── traefik.io_middlewares.yaml
│   ├── traefik.io_middlewaretcps.yaml
│   ├── traefik.io_serverstransports.yaml
│   ├── traefik.io_serverstransporttcps.yaml
│   ├── traefik.io_tlsoptions.yaml
│   ├── traefik.io_tlsstores.yaml
│   └── traefik.io_traefikservices.yaml
├── EXAMPLES.md
├── Guidelines.md
├── LICENSE
├── README.md
├── templates
│   ├── daemonset.yaml
│   ├── dashboard-ingressroute.yaml
│   ├── deployment.yaml
│   ├── extra-objects.yaml
│   ├── gatewayclass.yaml
│   ├── gateway.yaml
│   ├── healthcheck-ingressroute.yaml
│   ├── _helpers.tpl
│   ├── hpa.yaml
│   ├── ingressclass.yaml
│   ├── NOTES.txt
│   ├── poddisruptionbudget.yaml
│   ├── _podtemplate.tpl
│   ├── prometheusrules.yaml
│   ├── provider-file-cm.yaml
│   ├── pvc.yaml
│   ├── rbac
│   │   ├── clusterrolebinding.yaml
│   │   ├── clusterrole.yaml
│   │   ├── podsecuritypolicy.yaml
│   │   ├── rolebinding.yaml
│   │   ├── role.yaml
│   │   └── serviceaccount.yaml
│   ├── _service-metrics.tpl
│   ├── service-metrics.yaml
│   ├── servicemonitor.yaml
│   ├── _service.tpl
│   ├── service.yaml
│   ├── tlsoption.yaml
│   └── tlsstore.yaml
├── VALUES.md
└── values.yaml
$ helm template traefik traefik/traefik --namespace=kube-system > traefik.yaml
```

## [函数库](https://helm.sh/docs/chart_template_guide/function_list/)

Helm 模板支持以下函数库：

1. **Sprig**: Sprig 是一个 Go 语言的函数库，提供了一系列用于处理字符串、日期、字典、加密等常见任务的函数。例如，你可以使用`trim`函数来删除字符串的前导和尾随空格，或者使用`upper`函数将字符串转换为大写。

2. **Helm 内置函数**: Helm 还提供了一些内置函数，例如`include`用于包含并解析其他模板，`required`用于声明某个值是必需的，如果该值为空或不存在，Helm 将停止并返回错误。

3. **Pipelines and flow control**: Helm 模板支持 Go 语言的管道和流控制结构，例如`if`、`else`、`with`、`range`等。

4. **Values functions**: Helm 还提供了一些函数用于处理 values 文件中的值，例如`.Values`用于访问 values 文件中的值，`.Files`用于访问 chart 中的文件，`.Capabilities`用于访问 Kubernetes 集群的功能。

5. **Chart functions**: Helm 还提供了一些函数用于处理 chart，例如`.Chart`用于访问 chart 的元数据，`.Release`用于访问 release 的信息，`.Template`用于访问当前模板的信息。

## [Named Templates](https://helm.sh/docs/chart_template_guide/named_templates/)

1. Named Templates，也被称为 partials 或 subtemplates，是在文件中定义并赋予名称的模板。
2. 在命名模板时，模板名称是全局的。如果声明了两个同名的模板，最后加载的那个将被使用。
3. 为了避免命名冲突，一种常见的命名约定是在每个定义的模板前加上图表的名称，例如：`{{ define "mychart.labels" }}`。
4. 文件名以下划线（\_）开头的文件被认为不包含清单。这些文件不会被渲染为 Kubernetes 对象定义，但可以在其他图表模板中使用。
5. `define` 动作允许我们在模板文件中创建一个命名模板。例如，我们可以定义一个模板来封装 Kubernetes 的标签块。
6. `template` 动作允许我们在现有的 ConfigMap 中嵌入这个模板，然后使用 `template` 动作来包含它。
7. `include` 函数允许我们将模板的内容导入到当前的管道中，其中它可以被传递给管道中的其他函数。
8. 在定义的模板中，我们可以包含图表名称和图表版本。如果我们在渲染时遇到错误，我们可以通过传递作用域给模板来解决这个问题。
9. 在 Helm 模板中，使用 `include` 而不是 `template` 是更好的选择，因为这样可以更好地处理输出格式化。

## 访问模板中的文件

在 Helm 中，你可以通过 `.Files` 对象访问文件。这使得你可以在模板中导入非模板文件，并在不通过模板渲染器处理内容的情况下注入其内容。以下是一些关键点：

1. 你可以向 Helm 图表添加额外的文件，这些文件将被打包。但是要注意，由于 Kubernetes 对象的存储限制，图表的大小必须小于 1M。
2. 出于安全原因，有些文件不能通过 `.Files` 对象访问，例如 `templates/` 目录中的文件，被 `.helmignore` 排除的文件，以及 Helm 应用子图表之外的文件。
3. Helm 不保留 UNIX 模式信息，因此文件级权限对 `.Files` 对象可用文件的影响无效。
4. 你可以使用 `.Files` 对象的方法，如 `Get`，`Glob`，`Lines` 等，来读取文件内容或获取文件列表。
5. 你可以使用 `AsConfig` 和 `AsSecrets` 方法将文件内容放入 ConfigMaps 和 Secrets 中。
6. 你可以使用 `b64enc` 函数将文件内容进行 base-64 编码，以确保成功传输。
7. 在 Helm 安装期间，无法传递图表外部的文件。所以如果你要求用户提供数据，必须使用 `helm install -f` 或 `helm install --set` 来加载。

## [子 Charts](https://helm.sh/docs/chart_template_guide/subcharts_and_globals/)

Subcharts and Global Values 是 Helm 中的两个重要概念。

1. **Subcharts**：Subcharts 是 Helm chart 的依赖项，它们也有自己的值和模板。Subcharts 被视为 "stand-alone"，这意味着它们不能显式地依赖于其父 chart。因此，Subchart 不能访问其父 chart 的值。但是，父 chart 可以覆盖 Subcharts 的值。

2. **Global Values**：Helm 有一个全局值的概念，所有的 chart 都可以访问这些值。全局值需要显式声明，不能将现有的非全局值当作全局值使用。全局值可以在 `Values.global` 中设置。

创建 Subchart 的步骤如下：

- 在 `mychart/charts` 目录下创建一个新的 chart（例如，`mysubchart`）。
- 删除所有基础模板，以便从头开始。
- 在 `mysubchart` 中创建一个简单的模板和值文件。

父 chart 可以覆盖 Subchart 的值。例如，我们可以在 `mychart/values.yaml` 中修改 `mysubchart` 的 `dessert` 值。

全局值可以被任何 chart 或 subchart 访问。例如，我们可以在 `mychart/values.yaml` 文件中设置一个全局值 `salad`，然后在 `mychart/templates/configmap.yaml` 和 `mysubchart/templates/configmap.yaml` 中都可以访问这个值。

父 chart 和 subchart 可以共享模板。任何在任何 chart 中定义的块都可以被其他 chart 使用。例如，我们可以定义一个简单的模板 `labels`，然后在任何其他 chart 中都可以包含这个模板。

注意，Go 模板语言提供了一个 `block` 关键字，允许开发者提供一个默认实现，然后在后面覆盖它。但在 Helm charts 中，`block` 不是覆盖的最佳工具，因为如果提供了多个相同的 `block` 实现，选择哪个是不可预测的。建议使用 `include`。

## `NOTES.txt` 文件

`NOTES.txt` 文件会在用户安装或升级 Helm chart 时显示。在这个文件中，我们使用了一些内置的 Helm 模板变量，如 `.Chart.Name` 和 `.Release.Name`，分别表示 chart 的名称和 release 的名称。用户可以通过运行 `helm status` 和 `helm get all` 命令来获取更多关于 release 的信息。

```txt
# NOTES.txt

感谢您安装 {{ .Chart.Name }}。

您的发布版本名为 {{ .Release.Name }}。

要了解更多关于发布版本的信息，请尝试：

$ helm status {{ .Release.Name }}
$ helm get all {{ .Release.Name }}
```

## `.helmignore` 文件

`.helmignore` 文件用于指定你不希望包含在 Helm chart 中的文件。如果这个文件存在，`helm package`命令在打包应用程序时，将忽略所有与`.helmignore`文件中指定的模式匹配的文件。这可以帮助避免将不必要的或敏感的文件或目录添加到你的 Helm chart 中。`.helmignore`文件支持 Unix shell glob 匹配、相对路径匹配和否定（以 ! 为前缀）。每行只考虑一个模式。

```txt
# .helmignore

# 忽略任何名为 .helmignore 的文件或路径

.helmignore

# 忽略任何名为 .git 的文件或路径

.git

# 忽略任何文本文件

\*.txt

# 仅忽略名为 mydir 的目录

mydir/

# 仅忽略顶级目录中的文本文件

/\*.txt

# 仅忽略顶级目录中的 foo.txt 文件

/foo.txt

# 忽略任何名为 ab.txt、ac.txt 或 ad.txt 的文件

a[b-d].txt

# 忽略 subdir 下的所有匹配 temp\* 的文件

_/temp_

_/_/temp\*
temp?
```
