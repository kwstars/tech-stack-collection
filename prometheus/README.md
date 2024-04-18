## [Architecture](https://prometheus.io/docs/introduction/overview/)

![Architecture](https://prometheus.io/assets/architecture.png)

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

### 检查

```bash
# 检查名为 "demo" 的 job 是否处于非活动状态（即，up 的值是否为 0）
up{job="demo"} == 0

# 按 job 计数，检查名为 "demo" 的 job 是否处于非活动状态
count by(job) (up{job="demo"} == 0)

# 检查名为 "demo_api_request_duration_seconds_count" 的指标（对应的 method 为 "PUT"）是否存在
absent(demo_api_request_duration_seconds_count{method="PUT"})

# 检查过去一小时内名为 "non-existent" 的 job 是否一直不存在
absent_over_time(up{job="non-existent"}[1h])
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

### [子查询](https://prometheus.io/docs/prometheus/latest/querying/examples/#subquery)

### [操作符](https://prometheus.io/docs/prometheus/latest/querying/operators/)

#### 二元操作符（Binary operators）

用于在两个表达式之间进行操作的符号。它们可以分为三类：

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

  # 返回所有的 HTTP 请求，除了那些返回 4xx 错误的请求
  http_requests_total unless http_requests_total{status=~"4.."}
  ```

#### 向量匹配（Vector matching）

在进行向量和向量的二元操作时，PromQL 提供了一些关键字来控制如何匹配两个向量中的时间序列，包括：

- **向量匹配关键字**：包括 `on`（基于给定的标签进行匹配）和 `ignoring`（忽略给定的标签进行匹配）。
- **组修饰符**：包括 `group_left`（多对一匹配，保留左侧向量的标签）和 `group_right`（多对一匹配，保留右侧向量的标签）。

进行向量匹配时，需要注意以下几点：

1. **标签匹配**：两个向量之间的每个时间序列必须具有完全相同的标签和值。如果标签或值不匹配，那么这两个时间序列就不会被匹配到一起。

2. **时间对齐**：向量匹配是基于时间的，因此两个向量的时间序列必须在同一时间点上有数据。如果一个向量在某个时间点有数据，而另一个向量在该时间点没有数据，那么这两个时间序列就不会被匹配到一起。

3. **结果向量的标签**：一对一向量匹配的结果向量将包含匹配的时间序列的所有标签和值。

4. **NaN 值**：如果在进行一对一向量匹配时，任何一方的值为 NaN，那么结果也将为 NaN。

5. **操作符**：一对一向量匹配可以使用任何二元操作符，如 `+`、`-`、`*`、`/`、`%`、`==`、`!=`、`>`、`<`、`>=`、`<=`。

##### **一对一向量匹配**

在一对一向量匹配中，两个向量之间的每个时间序列必须具有完全相同的标签和值。

```bash
# 当 process_open_fds 和 process_max_fds 的标签匹配的时候
process_open_fds / process_max_fds

# 计算 CPU 的空闲率。首先，我们计算每个 CPU 的空闲时间的速率（忽略 CPU 标签），然后我们计算所有 CPU 的总时间的速率（忽略模式和 CPU 标签）。最后，我们将空闲时间的速率除以总时间的速率，得到 CPU 的空闲率。
sum without(cpu)(rate(node_cpu_seconds_total{mode="idle"}[5m])) / ignoring(mode) sum without(mode, cpu)(rate(node_cpu_seconds_total[5m]))

# 计算每个实例的网络带宽使用率。首先，我们计算每个实例的网络发送速率和接收速率，然后我们将这两个速率相加，得到每个实例的总网络带宽使用率。
sum without(device)(rate(node_network_transmit_bytes_total[5m])) + on(instance) sum without(device)(rate(node_network_receive_bytes_total[5m]))
```

##### 多对一和一对多向量匹配

在多对一和一对多向量匹配中，一个向量的多个时间序列可以匹配到另一个向量的一个时间序列。

```bash
# 多对一向量匹配，使用 group_left 修饰符
sum without(cpu)(rate(node_cpu_seconds_total[5m])) / ignoring(mode) sum without(mode, cpu)(rate(node_cpu_seconds_total[5m])) # Error
sum without(cpu)(rate(node_cpu_seconds_total[5m])) / ignoring(mode) group_left sum without(mode, cpu(rate(node_cpu_seconds_total[5m])) # OK
```

### [函数](https://prometheus.io/docs/prometheus/latest/querying/functions/)

#### `rate()` 和 `irate()`

`rate()` 和 `irate()` 是用于计算时间序列的速率。

- `rate(v range-vector)`：计算在给定的时间范围内时间序列的平均速率。它适用于更长的时间范围，因为它会平滑掉短期的波动。

- `irate(v range-vector)`：计算在给定的时间范围内时间序列的即时速率。它适用于更短的时间范围，因为它会反映出短期的波动。

以下是一些真实的示例：

```promql
# 计算过去 5 分钟内所有实例的 CPU 使用率的平均速率
rate(node_cpu_seconds_total{mode="user"}[5m])

# 计算过去 1 分钟内所有实例的 CPU 使用率的即时速率
irate(node_cpu_seconds_total{mode="user"}[1m])
```

在这些示例中，我们首先使用 `rate()` 或 `irate()` 函数来计算每个实例的 CPU 使用率的平均速率或即时速率，然后我们可以使用这些速率来进行进一步的分析或警报。

> [!tip] `rate()` 和 `irate()` 的主要区别
>
> 1. **时间范围**:
>
>    - `rate()`函数会计算指标在给定时间范围内的平均变化率。它会考虑整个时间窗口内的数据点。
>    - `irate()`函数则只关注最近两个数据点之间的瞬时变化率。它只看最近的数据点，不考虑整个时间范围。
>
> 2. **响应速度**:
>
>    - `irate()`函数对于突发性变化更加敏感，可以快速捕捉指标的瞬时变化。
>    - `rate()`函数则更平滑，对于平稳变化的指标更适用。
>
> 3. **用途**:
>    - `rate()`通常用于监控长期趋势和指标的平均变化速度。
>    - `irate()`则更适合用于检测短期异常情况和突发性变化，例如报警触发。
>
> 总的来说，如果您需要关注指标的长期趋势和平均变化速度，使用`rate()`函数更合适。而如果您需要快速检测指标的突发性变化，`irate()`函数会是更好的选择。

#### `predict_linear()`

`predict_linear` 是 Prometheus 的一种预测函数，它可以用于预测在给定的时间范围内，时间序列的值将如何线性地增加或减少。这对于预测磁盘使用率等资源的未来使用情况非常有用。

以下是一个使用 `predict_linear` 预测未来一小时内磁盘使用率的示例：

```promql
predict_linear(node_filesystem_avail_bytes{mountpoint="/"}[1h], 3600) < 0
```

这个表达式的含义是，预测在未来一小时（3600 秒）内，根文件系统（`mountpoint="/"`）的可用字节（`node_filesystem_avail_bytes`）将如何变化。如果返回的值小于 0，那么这意味着预计在未来一小时内，磁盘空间将耗尽。

这个表达式的结果可以用于设置警报，以便在磁盘空间可能耗尽之前得到通知。

需要注意的是，`predict_linear` 函数使用的是线性回归模型，这意味着它假设过去的趋势将在未来继续。这可能不总是正确的，因此在使用这个函数时需要谨慎。

#### `sort()` 和 `sort_desc()`

`sort()` 和 `sort_desc()` 是用于对向量进行排序。

- `sort(v instant-vector)`：返回一个新的向量，其中包含了输入向量的所有元素，但是这些元素按照它们的样本值升序排序。

- `sort_desc(v instant-vector)`：返回一个新的向量，其中包含了输入向量的所有元素，但是这些元素按照它们的样本值降序排序。

以下是一些示例：

```promql
# 对所有实例的 CPU 使用率进行升序排序
sort(rate(node_cpu_seconds_total{mode="user"}[5m]))

# 对所有实例的 CPU 使用率进行降序排序
sort_desc(rate(node_cpu_seconds_total{mode="user"}[5m]))
```

在这些示例中，我们首先使用 `rate()` 函数来计算每个实例的 CPU 使用率，然后我们使用 `sort()` 或 `sort_desc()` 函数来对这些使用率进行升序或降序排序。

#### `histogram_quantile()`

`histogram_quantile(φ scalar, b instant-vector)` 是 Prometheus 中的一个内置函数，用于从经典直方图或原生直方图中计算 φ-分位数（0 ≤ φ ≤ 1）。

以下是一些示例：

```bash
# 计算过去 10 分钟内请求持续时间的 90th 百分位数
histogram_quantile(0.9, rate(http_request_duration_seconds_bucket[10m]))

# 如果 http_request_duration_seconds 是原生直方图，使用以下表达式
histogram_quantile(0.9, rate(http_request_duration_seconds[10m]))

# 按 job 聚合 90th 百分位数
histogram_quantile(0.9, sum by (job, le) (rate(http_request_duration_seconds_bucket[10m])))

# 当聚合原生直方图时，表达式简化为：
histogram_quantile(0.9, sum by (job) (rate(http_request_duration_seconds[10m])))

# 聚合所有经典直方图，只指定 le 标签：
histogram_quantile(0.9, sum by (le) (rate(http_request_duration_seconds_bucket[10m])))

# 对于原生直方图，聚合所有内容的操作如常规操作一样，不需要任何 by 子句：
histogram_quantile(0.9, sum(rate(http_request_duration_seconds[10m])))
```

在这些示例中，我们首先使用 `rate()` 函数来指定分位数计算的时间窗口，然后我们使用 `histogram_quantile()` 函数来计算 φ-分位数。我们还可以使用 `sum by()` 函数来按照特定的标签进行聚合。

### 聚合

#### [基于标签的聚合](https://prometheus.io/docs/prometheus/latest/querying/operators/#aggregation-operators)

Prometheus 支持以下内置聚合运算符，可用于聚合单个瞬时向量的元素，生成具有聚合值的新向量：

- sum：在指定的维度上计算总和。该函数将相同标签组合的值相加，生成一个新的时间序列，其值为该组合下所有样本值的总和。
- min：在指定的维度上选择最小值。该函数将返回每组相同标签组合下的最小样本值，生成一个新的时间序列。
- max：在指定的维度上选择最大值。该函数将返回每组相同标签组合下的最大样本值，生成一个新的时间序列。
- avg：在指定的维度上计算平均值。该函数将计算每组相同标签组合下的样本值的平均值，生成一个新的时间序列。
- group：结果向量中的所有值都为 1。该函数将每个元素的值都设置为 1，生成一个新的时间序列。
- stddev：在指定的维度上计算总体标准偏差。该函数将计算每组相同标签组合下的样本值的总体标准偏差，生成一个新的时间序列。
- stdvar：在指定的维度上计算总体标准方差。该函数将计算每组相同标签组合下的样本值的总体标准方差，生成一个新的时间序列。
- count：计算向量中元素的数量。该函数将返回每组相同标签组合下的元素数量，生成一个新的时间序列。
- count_values：计算具有相同值的元素的数量。该函数将返回每个唯一样本值的出现次数，生成一个新的时间序列。
- bottomk：按样本值选择最小的 k 个元素。该函数将返回每组相同标签组合下的最小 k 个样本值，生成一个新的时间序列。
- topk：按样本值选择最大的 k 个元素。该函数将返回每组相同标签组合下的最大 k 个样本值，生成一个新的时间序列。
- quantile：在指定的维度上计算 φ-分位数（0 ≤ φ ≤ 1）。该函数将计算每组相同标签组合下的样本值的分位数，生成一个新的时间序列。

Prometheus 的聚合操作符可以用于对标签维度进行聚合，或者通过包含 `without` 或 `by` 子句来保留不同的维度。这些子句可以在表达式之前或之后使用。

聚合操作的一般形式如下：

```bash
<aggr-op> [without|by (<label list>)] ([parameter,] <vector expression>)
# 或
<aggr-op>([parameter,] <vector expression>) [without|by (<label list>)]
```

其中，`<label list>` 是一个未加引号的标签列表，可以包含尾随逗号，例如 `(label1, label2)` 和 `(label1, label2,)` 都是有效的语法。

`without` 会从结果向量中移除列出的标签，而所有其他标签都会保留在输出中。`by` 则相反，它会丢弃在 `by` 子句中未列出的标签，即使它们的标签值在向量的所有元素之间都是相同的。

`parameter` 只对 `count_values`、`quantile`、`topk` 和 `bottomk` 是必需的。

`count_values` 输出每个唯一样本值的一个时间序列。每个序列都有一个额外的标签。该标签的名称由聚合参数给出，标签值是唯一的样本值。每个时间序列的值是该样本值出现的次数。

`topk` 和 `bottomk` 与其他聚合器不同，它们在结果向量中返回输入样本的一个子集，包括原始标签。`by` 和 `without` 仅用于对输入向量进行分桶。

以下是一些示例：

```bash
# 计算所有文件系统的总大小，但不考虑文件系统类型和挂载点
sum without(fstype, mountpoint)(node_filesystem_size_bytes)

# 计算所有文件系统的总大小，不考虑任何标签
sum without()(node_filesystem_size_bytes)

# 获取所有文件系统的大小
node_filesystem_size_bytes

# 按照job、实例和设备对所有文件系统的大小进行求和
sum by(job, instance, device)(node_filesystem_size_bytes)

# 对所有的指标名称进行计数，并按照结果降序排序
sort_desc(count by(__name__)({__name__=~".+"}))

# 按照系统版本对节点信息进行计数
count by(release)(node_uname_info)

# 计算所有文件系统的总大小，不考虑任何标签
sum by()(node_filesystem_size_bytes)

# 计算所有文件系统的总大小
sum(node_filesystem_size_bytes)

# 尝试对不存在的指标进行求和，结果将为NaN
sum(non_existent_metric)

# 返回 CPU 使用率最高的前 5 个实例
topk(5, rate(node_cpu_seconds_total{mode="user"}[5m]))

# 返回 CPU 使用率最低的前 5 个实例
bottomk(5, rate(node_cpu_seconds_total{mode="user"}[5m]))
```

#### [基于时间的聚合](https://prometheus.io/docs/prometheus/latest/querying/functions/#aggregation_over_time)

Prometheus 提供了一系列基于时间的聚合函数，这些函数可以对给定范围向量的每个序列进行时间聚合，并返回一个包含每个序列聚合结果的即时向量。

以下是一些示例：

```bash
# 计算过去一小时内所有点的平均值
avg_over_time(http_requests_total[1h])

# 要查询 1 小时内内存的使用率
100 * (1 - ((avg_over_time(node_memory_MemFree_bytes[1h]) + avg_over_time(node_memory_Cached_bytes[1h]) + avg_over_time(node_memory_Buffers_bytes[1h])) / avg_over_time(node_memory_MemTotal_bytes[1h])))
```

注意，所有这些函数都假设在指定的间隔内，所有的值都有相同的权重，即使这些值在间隔内的分布不均匀。

## [Relabeling](https://prometheus.io/docs/prometheus/latest/configuration/configuration/#relabel_config)

Relabeling 允许在数据被 Prometheus 抓取之前动态地重写标签。这对于根据特定的规则过滤、聚合或修改抓取到的时间序列数据非常有用。

Relabeling 的配置通常在 Prometheus 的配置文件中的 `scrape_configs` 部分进行。每个 `scrape_config` 都包含一个 `relabel_configs` 部分，其中包含一系列的 relabeling 规则。

Prometheus 配置中的 relabeling 有`relabel_configs`、`metric_relabel_configs` 和 `alert_relabel_configs`，它们在 Prometheus 抓取和报警流程中的应用时间点和目标不同。

- `relabel_configs`：在 Prometheus 抓取目标之前应用，可以用于修改抓取目标的地址、协议方案或路径，或者基于目标的元标签来过滤目标。这些规则也可以用于添加、修改或删除目标的标签。

- `metric_relabel_configs`：在 Prometheus 抓取目标并解析度量之后应用。它们可以用于添加、修改或删除度量的标签，或者基于度量的标签来过滤度量。

- `alert_relabel_configs`：这些规则在 Prometheus 报警规则生成报警之后应用。它们可以用于添加、修改或删除报警的标签，或者基于报警的标签来过滤报警。

因此，`relabel_configs` 主要用于对抓取目标进行操作，`metric_relabel_configs` 主要用于对度量进行操作，而 `alert_relabel_configs` 主要用于对报警进行操作。

### 特殊标签

在 Prometheus 中，以双下划线 "\_\_" 开头的标签通常被视为隐藏标签。这些标签通常用于内部目的，而不是用户可见或直接操作的。以下是一些常见的隐藏标签：

1. `__address__`: 目标的地址（主机名和端口）。
2. `__scheme__`: 目标的通信协议（例如，http、https）。
3. `__metrics_path__`: 目标的指标路径（例如，/metrics）。
4. `__param_<name>`: 目标 URL 中传递的参数 `<name>` 的值。
5. `__meta_<label>`: 由服务发现机制提供的元数据标签，其中 `<label>` 是元数据标签的名称。
6. `__scrape_interval__`: 目标的抓取间隔。
7. `__scrape_timeout__`: 目标的抓取超时时间。
8. `__meta_XXXXXX` ：在服务发现阶段添加到目标的标签中的，提供了关于目标的元数据信息。
9. `__tmp`：假设在一个重标签步骤中需要计算或提取一个值，并将其用作后续步骤的输入，可以将其存储在一个以 `__tmp` 前缀开头的临时标签中，以确保它不会与其他标签冲突，并且在完成重标签过程后被正确清除。

这些隐藏标签通常在目标重标签后被移除，因为它们通常用于内部目的而不是用户可见。

### 规则

以下是 relabeling 规则的各个配置项的含义：

- `source_labels`: 这是一个标签名称的数组，用于选择现有标签的值。这些值会被连接起来，然后匹配下面配置的正则表达式。
- `separator`: 这是一个字符串，用于连接 `source_labels` 中的值。默认值是分号 ";"。
- `target_label`: 这是一个标签名称，用于在 replace 动作中写入结果值。在 replace 动作中，这是必需的。正则表达式的捕获组可以在这里使用。
- `regex`: 这是一个正则表达式，用于匹配提取的值。默认值是 `(.*)`，匹配任何值。
- `modulus`: 这是一个整数，用于取源标签值的哈希的模。
- `replacement`: 这是一个字符串，用于在正则表达式匹配时进行替换。正则表达式的捕获组可以在这里使用。默认值是 `$1`，表示第一个捕获组。
- `action`: 这是一个动作，基于正则表达式的匹配结果进行。默认值是 `replace`。可选的动作有 `replace`、`keep`、`drop`、`hashmod`、`labelmap`、`labeldrop` 和 `labelkeep`。

以下是一些示例：

```yaml
# 设置或替换标签值
relabel_configs:
  - source_labels: [__address__] # 源标签，我们选择 __address__ 这个内置标签
    separator: ; # 连接源标签值的分隔符，这里我们只有一个源标签，所以这个字段实际上没有用到
    regex: (.*):.* # 正则表达式，用于匹配源标签值，这里我们提取出地址中的主机名部分（即冒号 : 之前的部分）
    replacement: $1 # 替换字符串，这里我们使用第一个捕获组（即主机名部分）作为替换字符串
    target_label: instance # 目标标签，我们将替换字符串设置为 instance 标签的值

# 设置一个固定的标签值
relabel_configs:
  - target_label: 'environment'
    replacement: 'production'

# 替换抓取任务端口
relabel_configs:
  - source_labels: [__address__]
    regex: ([^:]+)(?::\d+)? # 第一个捕获组匹配的是 host，第二个匹配的是 port 端口。
    replacement: $1:9090
    target_label: __address__

# 保留了所有 __meta_kubernetes_service_annotation_prometheus_io_scrape 标签值为 true 的目标。这样就可以只抓取那些我们想要监控的服务。
relabel_configs:
  - source_labels: [__meta_kubernetes_service_annotation_prometheus_io_scrape]
    regex: true
    action: keep

# 丢弃了所有 __meta_kubernetes_pod_annotation_prometheus_io_scrape 标签值为 false 的目标。这样就可以避免抓取那些我们不想监控的 Pod。
relabel_configs:
  - source_labels: [__meta_kubernetes_pod_annotation_prometheus_io_scrape]
    regex: false
    action: drop

# 复制了名为 __meta_kubernetes_pod_label_app 的源标签，并将其设置为 app 标签。这样就可以在 Prometheus 中使用 app 标签来查询和聚合数据。
relabel_configs:
  - source_labels: [__meta_kubernetes_pod_label_app]
    regex: (.+)
    target_label: app
    action: labelmap

# 删除了所有以 __meta_kubernetes_pod_label_ 开头的标签。这样就可以减少 Prometheus 中的标签数量，从而提高查询性能。
relabel_configs:
  - regex: __meta_kubernetes_pod_label_(.+)
    action: labeldrop

# 保留了名为 __meta_kubernetes_pod_label_app 和 __meta_kubernetes_pod_label_version 的标签。这样就可以在 Prometheus 中使用这两个标签来查询和聚合数据，而其他的标签则会被删除。
relabel_configs:
  - regex: __meta_kubernetes_pod_label_(app|version)
    action: labelkeep

# 首先使用 hashmod 操作对 __address__ 标签的值进行哈希，并将结果对 10 取模，然后将结果存储在 __tmp_hash 标签中。接下来，它使用 keep 操作保留 __tmp_hash 标签值为 2 的目标，其他的目标都会被丢弃。这样，你就可以将 Prometheus 的抓取任务分片到多个 Prometheus 实例上，每个实例只抓取一部分目标。
relabel_configs:
  - source_labels: [__address__]
    modulus: 10
    action: hashmod
    target_label: __tmp_hash
  - action: keep
    source_labels: [__tmp_hash]
    regex: 2
```

推荐使用 [relabeler 工具](https://relabeler.promlabs.com/) 进行测试。这是一个强大的工具，可以帮助你更好地理解和应用 Relabeling。

## [服务发现](https://prometheus.io/docs/prometheus/latest/configuration/configuration/)

## [Exporter](https://prometheus.io/docs/instrumenting/exporters/)

## [Pushgateway](https://prometheus.io/docs/practices/pushing/)

## [AlertManager](https://prometheus.io/docs/alerting/latest/alertmanager/)

## Grafana

### [添加数据源](https://grafana.com/docs/grafana/latest/datasources/)

### [添加 Dashboard](https://grafana.com/docs/grafana/latest/dashboards/)

在 "Panel" 页面中，你可以配置你的图表。在 "Query" 部分，你可以输入你的 PromQL 查询。例如，如果你想显示 CPU 使用率，你可以输入以下的 PromQL 查询：

```promql
# CPU使用率
100 - (avg by (instance) (irate(node_cpu_seconds_total{mode="idle"}[5m])) * 100)

# 内存使用率
avg by (instance) ((node_memory_MemTotal_bytes - node_memory_MemAvailable_bytes) / node_memory_MemTotal_bytes * 100)
```

### [可选择的 Variables](https://grafana.com/docs/grafana/latest/dashboards/variables/)

在 Grafana 中添加变量（variables）的步骤如下：

1. 在你的 Dashboard 页面，点击右上角的 "Dashboard settings" 按钮。

2. 在 "Dashboard settings" 页面中，点击左侧的 "Variables" 菜单。

3. 在 "Variables" 页面中，点击右上角的 "New Variables" 按钮。

4. 在 "New Variable" 页面中，你可以配置你的变量。以下是一些基本的配置：

   - General -> Name: 输入变量的名称，例如 "host"。

   - General -> Label: 输入变量的标签，例如 "选择节点"。

   - Type: 选择 "Query result"。

   - Data source: 选择你的 Prometheus 数据源。

   - Query options -> Query: 输入你的 PromQL 查询来获取 `host` 的值。例如，你可以输入以下的查询：

     ```promql
     up{job="node"}
     ```

   - Query options -> Regex: 输入一个正则表达式来从查询结果中提取 `host` 的值。例如，你可以输入以下的正则表达式：

     ```regex
     .*{instance="(.*?)".*
     ```

   - Selection options -> Include All option: 勾选这个选项，然后在 "Custom all value" 中输入 `.*`。

5. 完成配置后，点击右下角的 "Apply" 按钮。

6. 返回到 Dashboard 页面，你可以在 Dashboard 的顶部看到你的新变量。你可以从下拉菜单中选择一个 `host`，然后你的 Dashboard 会根据你选择的 `host` 更新。

   ```promql
   # CPU使用率
   100 - (avg by (instance) (irate(node_cpu_seconds_total{instance=~"$host", mode="idle"}[5m])) * 100)

   # 内存使用率
   avg by (instance) ((node_memory_MemTotal_bytes{instance=~"$host"} - node_memory_MemAvailable_bytes{instance=~"$host"}) / node_memory_MemTotal_bytes{instance=~"$host"} * 100)
   ```

## Thanos
