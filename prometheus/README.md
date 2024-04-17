## PromQL

PromQL 是 Prometheus Query Language 的缩写，是 Prometheus 提供的一种强大的数据查询语言。

### [PromLens](https://demo.promlens.com/)

PromLens 是一个用于帮助开发者理解和编写 PromQL（Prometheus Query Language）查询的在线工具。Prometheus 是一个开源的系统监控和警报工具包，而 PromQL 是 Prometheus 的查询语言。

PromLens 提供了以下功能：

- **查询分析**：PromLens 可以将 PromQL 查询分解成可视化的树形结构，帮助你理解查询的工作原理。
- **查询优化**：PromLens 可以提供关于如何优化你的 PromQL 查询的建议，以提高查询效率和减少 Prometheus 服务器的负载。
- **查询构建**：PromLens 提供了一个交互式的查询构建器，可以帮助你构建复杂的 PromQL 查询，无需手动编写查询语句。

请注意，PromLens 是一个商业产品，虽然它提供了一个免费的在线演示版本，但是某些功能可能需要购买许可证才能使用。

### [数据模型](https://prometheus.io/docs/concepts/data_model/)

Prometheus 的数据模型主要由以下两个部分组成：

1. **序列标识符（Series identifiers）**：每个系列都由一个指标名称和一组称为 "标签" 的键/值对唯一标识。

   指标名称标识了正在测量的系统的总体方面（例如 `http_requests_total`，由给定服务器进程处理的 HTTP 请求的总数）。

   标签允许你将一个指标划分为子维度（例如 `method="GET"` vs `method="POST"` 告诉你处理了每种 HTTP 方法类型的多少请求）。标签可以有不同的来源：例如，一个被监控的目标可能本身就暴露了已经由一组标签分割的指标，或者 Prometheus 服务器可能会将目标标签附加到收集的系列上，以标识它们来自何处。

   形成系列标识符的指标名称和标签在 Prometheus 的 TSDB 中被索引，并用于在查询数据时查找系列。

2. **序列样本（Series samples）**：样本形成了系列的大部分数据，并随着时间的推移被追加到索引的系列中：

   时间戳是毫秒精度的 64 位整数。

   样本值是 64 位浮点数（允许整数精度达到 2^53）。

![](https://training.promlabs.com/static/prometheus-data-model-c49187d58a88082bca9ca028d7b3fe4b.svg)

### [指标类型](https://prometheus.io/docs/concepts/metric_types/)

指标类型（Metric Types）是由**抓取目标报告的**，用于描述指标性质和行为的类型。Prometheus 支持四种指标类型：

1. **Counter（计数器）**：一个只能增加（或重置）的指标，常用于表示累计值。

   ```bash
   # 表示 Prometheus 服务器接收到的 HTTP 请求的总数。
   prometheus_http_requests_total
   ```

2. **Gauge（仪表）**：一个可以任意上下浮动的指标，常用于表示当前值。

   ```bash
   # `node_memory_MemAvailable_bytes` 表示当前可用的内存量（以字节为单位），`node_disk_io_now` 表示当前磁盘 I/O 操作的数量。
   node_memory_MemAvailable_bytes
   node_disk_io_now
   ```

3. **Histogram（直方图）**：一个可以对观察结果进行采样并计数，然后在可配置的桶中累积的指标。

   ```bash
   # 表示处理 `/api/v1/query` 路径的 HTTP 请求中，持续时间小于或等于 0.1 秒的请求的数量。
   prometheus_http_request_duration_seconds_bucket{le="0.1"，handler="/api/v1/query"}
   ```

4. **Summary（摘要）**：一个可以对观察结果进行采样并计数，然后计算滑动时间窗口内的可配置百分位数的指标。

   ```bash
   # 表示 job 标签为 "prometheus" 的 Go 垃圾回收过程中，所有持续时间的最大值（quantile="1" 表示 100% 的分位数，即最大值）。
   go_gc_duration_seconds{job="prometheus"， quantile="1"}
   ```

请注意，Histogram 和 Summary 都可以用来表示分布（如请求持续时间），但是它们在处理方式和性能上有所不同。Histogram 通过预定义的桶来收集数据，因此可以提供更好的性能和更少的错误，但是需要提前知道数据的分布。Summary 则可以计算任意百分位数，但是计算成本更高，而且在不同的 Prometheus 服务器之间不可聚合。

### [查询基础](https://prometheus.io/docs/prometheus/latest/querying/basics/)

#### [表达式结果数据类型](https://prometheus.io/docs/prometheus/latest/querying/basics/#expression-language-data-types)

结果数据类型（Expression language data types）在 PromQL 查询中使用的数据类型，描述了**查询结果**的形式。PromQL 支持四种数据类型：

1. **瞬时向量（Instant vector）**：表示一组时间序列，每个时间序列都包含一个单一的样本，这些样本都共享相同的时间戳。这意味着表达式的返回值只会包含每个时间序列中最新的一个样本值。

   ```bash
   # 表示 Prometheus 服务器接收到的 HTTP 请求的总数。
   prometheus_http_requests_total
   ```

2. **区间向量（Range vector）**：表示一组时间序列，每个时间序列都包含一段时间范围内的样本数据，这些数据是通过在瞬时向量后附加时间选择器（例如 [5m] 表示最近 5 分钟）来生成的。

   ```bash
   # 表示过去 5 分钟内 Prometheus 服务器接收到的 HTTP 请求的总数。
   prometheus_http_requests_total[5m]
   ```

3. **标量（Scalar）**：一个简单的数字浮点值。主要来源于以下几种情况：

   1. 直接的数字字面量，例如 `5`、`0.1`、`-3.14` 等。
   2. 一些函数的返回结果，例如 `time()`、`day_of_month()`、`hour()` 等。
   3. 瞬时向量（Instant vector）经过聚合操作后得到的结果，例如 `sum(http_requests_total)`、`avg(cpu_usage)` 等。

   ```bash
   # 直接的数字字面量
   5

   # 使用 time() 函数获取当前时间戳
   time()

   # 对 http_requests_total 指标进行求和操作
   sum(http_requests_total)
   ```

4. **字符串（String）**：一个简单的字符串值。主要来源于以下几种情况：

   1. 直接的字符串字面量，例如 `"hello"`、`'world'`、`"Prometheus"` 等。
   2. 一些函数的返回结果，例如 `label_replace()`、`label_join()` 等。

   ```bash
   # 直接的字符串字面量
   "hello"
   
   # 使用 label_replace() 函数替换标签值
   label_replace(http_requests_total， "method"， "$1"， "method"， "(.*)")
   ```

#### [选择器](https://prometheus.io/docs/prometheus/latest/querying/examples/#simple-time-series-selection)

PromQL 提供了强大的选择操作，可以根据指标名称和标签进行精确或模糊查询。以下是一些基本的选择操作：

1. **简单的时间序列选择**：返回具有指定指标的所有时间序列。

   ```bash
   # Prometheus 服务器接收到的 HTTP 请求的总数
   prometheus_http_requests_total
   ```

2. **带标签的选择**：返回具有指定指标和给定标签的所有时间序列。标签选择器允许你通过 `=` 来选择标签值完全等于给定字符串的标签，通过 `!=` 来选择标签值不等于给定字符串的标签，通过 `=~` 来选择标签值符合给定正则表达式的标签，以及通过 `!~` 来选择标签值不符合给定正则表达式的标签。

   ```bash
   # 请求处理器为 "/api/v1/query"
   prometheus_http_requests_total{code="200"， handler="/api/v1/query"}
   # 请求处理器匹配正则表达式 "/api/v1/.*"
   prometheus_http_requests_total{code="200"， handler=~"/api/v1/.*"}
   # 请求处理器不匹配正则表达式 "/api/v1/.*"
   prometheus_http_requests_total{code="200"， handler!~"/api/v1/.*"}
   ```

3. **范围向量选择（Range Vector Selectors）**：返回指定时间范围内的时间序列。时间持续性是由一个数字后面紧跟一个单位来指定的，包括毫秒（ms）、秒（s）、分钟（m）、小时（h）、天（d，假设一天总是 24 小时）、周（w，假设一周总是 7 天）和年（y，假设一年总是 365 天）。时间持续性可以通过连接来组合，单位必须从最长到最短进行排序，每个单位在一个时间持续性中只能出现一次。

   ```bash
   # 过去 5 分钟内，Prometheus 服务器接收到的 HTTP 请求的总数，其中 HTTP 状态码为 200，请求处理器为 "/api/v1/query"
   prometheus_http_requests_total{code="200"， handler="/api/v1/query"}[5m]
   ```

4. **偏移修饰符（Offset modifier）**：允许在查询中改变单个瞬时向量和范围向量的时间偏移。

   ```bash
   # 返回相对于当前查询评估时间过去 5 分钟的 http_requests_total 的值
   http_requests_total offset 5m

   # 注意，偏移修饰符总是需要紧跟在选择器后面，返回相对于当前查询评估时间过去 5 分钟的 GET 方法的 http_requests_total 的总和
   sum(http_requests_total{method="GET"} offset 5m) // 正确
   sum(http_requests_total{method="GET"}) offset 5m // 错误

   # 对于范围向量，偏移修饰符也同样适用。
   # 返回一周前 http_requests_total 的 5 分钟速率
   rate(http_requests_total[5m] offset 1w)
   # 返回相对于当前查询评估时间未来一周的 http_requests_total 的 5 分钟速率
   rate(http_requests_total[5m] offset -1w)
   ```

5. **`@`修饰符**：允许在查询中改变单个瞬时向量和范围向量的评估时间。提供给`@`修饰符的时间是一个 Unix 时间戳，用浮点数表示。

   ```bash
   # 返回 http_requests_total 在 2021-01-04T07:40:00+00:00 的值
   http_requests_total @ 1609746000
   
   # 返回 GET 方法的 http_requests_total 在 2021-01-04T07:40:00+00:00 的总和
   sum(http_requests_total{method="GET"} @ 1609746000) // 正确
   sum(http_requests_total{method="GET"}) @ 1609746000 // 错误
   
   # 对于范围向量，返回 http_requests_total 在 2021-01-04T07:40:00+00:00 的 5 分钟速率
   rate(http_requests_total[5m] @ 1609746000)
   ```

### [操作符](https://prometheus.io/docs/prometheus/latest/querying/operators/)

二元操作符（Binary operators）是用于在两个表达式之间进行操作的符号。它们可以分为三类：

- **算术二元操作符**：包括加（`+`）、减（`-`）、乘（`*`）、除（`/`）、取模（`%`）和幂（`^`）。
  ```bash
  # job 标签为 "prometheus" 的 Go 垃圾回收过程中，所有持续时间的最大值（quantile="1" 表示 100% 的分位数，即最大值）与总持续时间的比例。
  go_gc_duration_seconds_sum{job="prometheus"} / go_gc_duration_seconds{job="prometheus"， quantile="1"}
  ```
- **比较二元操作符**：包括等于（`==`）、不等于（`!=`）、大于（`>`）、小于（`<`）、大于等于（`>=`）和小于等于（`<=`）。这些操作符可以在两个标量之间，两个向量之间，或者一个标量和一个向量之间进行操作。
  ```bash
  # job 标签为 "prometheus" 的当前内存使用量是否超过了 1GB 的阈值。
  process_resident_memory_bytes{job="prometheus"} > 1e9
  ```
- **逻辑/集合二元操作符**：包括逻辑与（`and`）、逻辑或（`or`）和逻辑非（`unless`）。
  ```bash
  # 这是一个表示实例的 CPU 使用率超过 75% 并且内存使用量超过 2GB 的查询。
  (instance_cpu_usage_seconds_total > 0.75) and (instance_memory_usage_bytes > 2e9)
  ```

向量匹配（Vector matching）在进行向量和向量的二元操作时，PromQL 提供了一些关键字来控制如何匹配两个向量中的时间序列，包括：

- **向量匹配关键字**：包括 `on`（基于给定的标签进行匹配）和 `ignoring`（忽略给定的标签进行匹配）。

- **组修饰符**：包括 `group_left`（多对一匹配，保留左侧向量的标签）和 `group_right`（多对一匹配，保留右侧向量的标签）。

- **一对一向量匹配**：在一对一向量匹配中，两个向量之间的每个时间序列必须具有完全相同的标签和值。

- **多对一和一对多向量匹配**：在多对一和一对多向量匹配中，一个向量的多个时间序列可以匹配到另一个向量的一个时间序列。

### [函数](https://prometheus.io/docs/prometheus/latest/querying/functions/)

#### `rate()`

`rate(v range-vector)`函数计算范围向量中时间序列的每秒平均增长率。它会自动调整单调性中断（例如，由于目标重启导致的计数器重置）。此外，计算会外推到时间范围的两端，允许错过抓取或抓取周期与范围的时间周期不完全对齐。

以下示例表达式返回过去 5 分钟内每秒 HTTP 请求的速率，每个时间序列在范围向量中：

```bash
# 返回过去 5 分钟内每秒 HTTP 请求的速率
rate(prometheus_http_requests_total{handler="/metrics"}[5m])
```

`rate()`函数对原生直方图进行操作，计算一个新的直方图，其中每个组件（观察的总和和计数，桶）是 v 中第一个和最后一个原生直方图中相应组件的增长率。然而，v 中的每个元素如果在范围内包含浮点数和原生直方图样本的混合，将会在结果向量中缺失。

`rate()`函数应仅用于计数器和原生直方图，其中组件的行为类似于计数器。它最适合用于警报和慢移动计数器的图形化。

注意，当将 `rate()` 与聚合操作符（例如 `sum()`）或者一个聚合时间的函数（任何以 `_over_time` 结尾的函数）结合时，总是先取 `rate()`，然后再聚合。否则，当你的目标重启时，`rate()` 无法检测到计数器重置。

#### `irate()`

`irate(v range-vector)`函数计算范围向量中时间序列的每秒瞬时增长率。这是基于最后两个数据点的。它会自动调整单调性中断（例如，由于目标重启导致的计数器重置）。

以下示例表达式返回过去 5 分钟内每秒 HTTP 请求的速率，每个时间序列在范围向量中查找最近的两个数据点：

```bash
# 返回过去 5 分钟内每秒 HTTP 请求的速率
irate(prometheus_http_requests_total{handler="/metrics"}[5m])
```

`irate()`函数应仅用于图形化波动性大、变化快的计数器。对于警报和慢移动计数器，使用 `rate`，因为速率的短暂变化可以重置 `FOR` 子句，而且完全由稀有峰值组成的图形难以阅读。

注意，当将 `irate()` 与聚合操作符（例如 `sum()`）或者一个聚合时间的函数（任何以 `_over_time` 结尾的函数）结合时，总是先取 `irate()`，然后再聚合。否则，当你的目标重启时，`irate()` 无法检测到计数器重置。

> [!tip] `rate()` 和 `irate()` 的主要区别
>
> 1. **时间范围**:
>    - `rate()`函数会计算指标在给定时间范围内的平均变化率。它会考虑整个时间窗口内的数据点。
>    - `irate()`函数则只关注最近两个数据点之间的瞬时变化率。它只看最近的数据点，不考虑整个时间范围。
>
> 2. **响应速度**:
>    - `irate()`函数对于突发性变化更加敏感，可以快速捕捉指标的瞬时变化。
>    - `rate()`函数则更平滑，对于平稳变化的指标更适用。
>
> 3. **用途**:
>    - `rate()`通常用于监控长期趋势和指标的平均变化速度。
>    - `irate()`则更适合用于检测短期异常情况和突发性变化，例如报警触发。
>
> 总的来说，如果您需要关注指标的长期趋势和平均变化速度，使用`rate()`函数更合适。而如果您需要快速检测指标的突发性变化，`irate()`函数会是更好的选择。

### [聚合](https://prometheus.io/docs/prometheus/latest/querying/operators/#aggregation-operators)

### [范围向量](https://prometheus.io/docs/prometheus/latest/querying/basics/#range-vector-selectors)

### [子查询](https://prometheus.io/docs/prometheus/latest/querying/examples/#subquery)

```bash
# 'up' 是一个内置的 Prometheus 指标，表示目标实例的运行状态。如果实例正常运行，值为 1，如果实例不可达，值为 0。
up

# 'process_resident_memory_bytes' 是一个内置的 Prometheus 指标，表示进程的常驻内存大小，单位为字节。
process_resident_memory_bytes

# 'prometheus_tsdb_head_samples_appended_total' 是一个 Prometheus 指标，表示已追加到 Prometheus 时间序列数据库 (TSDB) "head" 的样本总数。
prometheus_tsdb_head_samples_appended_total

# 'rate(prometheus_tsdb_head_samples_appended_total[1m])' 是一个 PromQL 表达式，表示过去一分钟内 'prometheus_tsdb_head_samples_appended_total' 指标的速率。这可以用来监控 Prometheus TSDB 的写入速度。
rate(prometheus_tsdb_head_samples_appended_total[1m])

# 获取标签 job 等于 node_exporter 的 process_resident_memory_bytes 指标。这个指标表示 Node Exporter 进程的常驻内存大小，单位为字节。
process_resident_memory_bytes{job="node_exporter"}
```

## [服务发现](https://prometheus.io/docs/prometheus/latest/configuration/configuration/)

### Relabeling

### File

### HTTP

### Consul

## AlertManager

## Grafana

## Thanos
