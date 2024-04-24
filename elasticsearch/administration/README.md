## Reindexing documents

在 Elasticsearch 中，以下是一些可能需要重建索引的情况：

1. **映射更改**：如果你需要更改现有字段的类型或者添加新的字段到现有的映射中，你需要重建索引。在 Elasticsearch 中，一旦字段被索引，其类型就不能更改。
2. **分片数量更改**：如果你需要更改索引的分片数量，你需要重建索引。在 Elasticsearch 中，一旦索引被创建，其分片数量就不能更改。
3. **优化性能**：如果你需要优化查询性能，例如更改分词器或优化文档结构，你可能需要重建索引。
4. **删除旧数据**：如果你需要删除大量的旧数据，重建索引可能比删除单个文档更高效。
5. **升级 Elasticsearch 版本**：在某些情况下，升级 Elasticsearch 到新版本可能需要重建索引。

请注意，重建索引可能会消耗大量的计算资源，并可能导致服务中断，因此在进行重建索引操作时需要谨慎。

```json
GET _cat/health
GET _cat/nodes
GET _cat/indices
GET _cluster/state
```

## [配置修改方式](https://www.elastic.co/guide/en/elasticsearch/reference/current/cluster-update-settings.html)

1. **Transient Settings**：这些设置是临时的，只对当前运行的 Elasticsearch 实例有效。如果你重启 Elasticsearch，这些设置就会丢失。你可以使用 `_cluster/settings` API 来修改这些设置。例如：

   ```bash
   curl -X PUT "localhost:9200/_cluster/settings" -H 'Content-Type: application/json' -d'
   {
       "transient": {
           "cluster.routing.allocation.disk.threshold_enabled": false
       }
   }
   '
   ```

2. **Persistent Settings**：这些设置是持久的，即使你重启 Elasticsearch，这些设置也会保留。你也可以使用 `_cluster/settings` API 来修改这些设置。例如：

   ```bash
   curl -X PUT "localhost:9200/_cluster/settings" -H 'Content-Type: application/json' -d'
   {
       "persistent": {
           "indices.recovery.max_bytes_per_sec": "50mb"
       }
   }
   '
   ```

3. **Config file settings**：你可以在 Elasticsearch 的配置文件（默认是 `elasticsearch.yml`）中修改配置。例如：

   ```yaml
   cluster.name: my_cluster
   node.name: node_1
   ```

### 集群设置

关闭 Dynamic Indexes 功能

```
# 关闭动态索引创建功能
PUT _cluster/settings
{
  "persistent": {
    "action.auto_create_index": false
  }
}

# 这将允许创建以"logstash-"或".kibana"开头的索引，而其他索引将被拒绝。
PUT _cluster/settings
{
  "persistent": {
    "action.auto_create_index": "logstash-*，.kibana*"
  }
}
```

## 运维 Cheat Sheet

### 移动分片

当一个数据节点上有过多 Hot Shards; 可以通过手动分配分片到特定的节点解决。

在将名为 "test" 的索引的 shard 0 从 "node1" 移动到 "node2"。

```json
POST /_cluster/reroute
{
  "commands": [
    {
      "move": {
        "index": "test"，
        "shard": 0，
        "from_node": "node1"，
        "to_node": "node2"
      }
    }
  ]
}
```

### 从集群中移除一个节点

当你想移除一个节点，或者对一个机器进行维护。同时你又不希望导致集群的颜色变黄或者变红。

```json
PUT _cluster/settings
{
  "transient": {
    "cluster.routing.allocation.exclude._ip": "the_IP_of_your_node"
  }
}
```

这个命令会告诉 Elasticsearch 集群不要将新的分片分配给指定的 IP 地址。这样，当现有的分片被重新分配时，这个节点就会被逐渐清空。当节点上没有分片时，你就可以安全地移除这个节点，而不会影响集群的健康状态。

### 控制 Allocation 和 Recovery

```json
# 改变平衡集群时移动的分片数量
PUT /_cluster/settings
{
  "transient": {
    "cluster.routing.allocation.cluster_concurrent_rebalance": 2
  }
}

# 改变每个节点同时恢复的分片数量
PUT _cluster/settings
{
  "transient": {
    "cluster.routing.allocation.node_concurrent_recoveries": 5
  }
}

# 改变恢复速度
PUT /_cluster/settings
{
  "transient": {
    "indices.recovery.max_bytes_per_sec": "80mb"
  }
}

# 改变单个节点上的并发恢复流的数量
PUT _cluster/settings
{
  "transient": {
    "indices.recovery.concurrent_streams": 6
  }
}
```

### Synced Flush

在重启节点之前，使用 synced flush 可以提高分片恢复的速度。Synced flush 在所有副本分片上放置一个 sync ID，这样在节点重启后，如果主分片和副本分片的 sync ID 相同，那么 Elasticsearch 就不需要进行全量恢复，从而大大提高了恢复速度。

```json
POST _flush/synced
```

### 清空节点上的缓存

当节点上出现高内存占用时，执行清除缓存的操作是一种可能的解决方案。这个操作可能会影响集群的性能，因为清除缓存后，后续的查询可能需要重新加载数据到缓存中。但是，这个操作可以帮助避免集群出现 OutOfMemoryError (OOM) 的问题。

```bash
POST _cache/clear
```

### 控制搜索的队列

当搜索的响应时间过长，或者你看到 "rejected" 指标的增加时，增加 `threadpool.search.queue_size` 的值是一种可能的解决方案。这个设置控制了每个节点上等待执行的搜索操作的数量。增加这个值可以让更多的搜索请求排队等待执行，而不是被拒绝。

```bash
PUT _cluster/settings
{
  "transient": {
    "threadpool.search.queue_size": 2000
  }
}
```

### 设置 Circuit Breaker

设置 Circuit Breaker 是一种防止 OutOfMemoryError (OOM) 的有效方法。Circuit Breaker 会在 JVM 堆内存使用接近阈值时，阻止执行可能导致 OOM 的操作。

```bash
PUT _cluster/settings
{
  "persistent": {
    "indices.breaker.total.limit": "40%"
  }
}
```

### [备份和恢复（Snapshots）](https://www.elastic.co/guide/en/elasticsearch/reference/current/snapshot-restore.html)

```json
# 先在 `elasticsearch.yml` 中添加 `path.repo=/usr/share/elasticsearch/backup`
# 在 Elasticsearch 中注册一个位于 "/usr/share/elasticsearch/backup" 的文件系统（fs）类型的快照仓库。
PUT _snapshot/es_cluster_snapshot_repository
{
  "type": "fs",
  "settings": {
    "location": "/usr/share/elasticsearch/backup"
  }
}

# 在 "es_cluster_snapshot_repository" 仓库创建名为 "custom_prod_snapshots" 的快照，该快照将包含所有名称中包含 "movies" 和 "reviews" 的索引。
PUT _snapshot/es_cluster_snapshot_repository/custom_prod_snapshots
{
  "indices": ["*movies*","*reviews*"]
}


# 在 "es_cluster_snapshot_repository" 仓库创建名为 "custom_prod_snapshots_with_metadata" 的快照。该快照将包含所有名称中包含 "movies" 和 "reviews"，但不包含以 ".old" 结尾的索引。同时，这个快照还包含一些元数据，如 "reason"、"incident_id" 和 "user"。
PUT _snapshot/es_cluster_snapshot_repository/custom_prod_snapshots_with_metadata
{
  "indices": ["*movies*","*reviews*", "-*.old"],
  "metadata":{
    "reason":"user request",
    "incident_id":"ID12345",
    "user":"mkonda"
  }
}

# 列出所有快照的列表，并按照快照 ID 进行排序。
GET _cat/snapshots/es_cluster_snapshot_repository?v=true&s=id

# 获取 Elasticsearch 中所有的快照仓库。
GET _snapshot

# 获取 Elasticsearch 中所有快照的状态。
GET _snapshot/_status

# 获取 "es_cluster_snapshot_repository" 仓库当前正在进行的快照的状态。
GET _snapshot/es_cluster_snapshot_repository/_current


# 从 "es_cluster_snapshot_repository" 仓库的 "custom_prod_snapshots" 快照中恢复所有名称中包含 "movies" 的索引。
POST _snapshot/es_cluster_snapshot_repository/custom_prod_snapshots/_restore
{
  "indices":["*movies*"]
}

# 删除 "es_cluster_snapshot_repository" 仓库的 "custom_prod_snapshots" 快照。
DELETE _snapshot/es_cluster_snapshot_repository/custom_prod_snapshots



# 创建一个名为 "prod_cluster_daily_backups" 的快照生命周期管理（SLM）策略。这个策略会在每天的 00:00:00 执行，创建一个名为 "<prod_daily_backups-{now/d}>" 的快照，该快照将包含所有名称中包含 "movies" 和 "reviews" 的索引，并存储在 "es_cluster_snapshot_repository" 仓库中。这个策略不包含全局状态，不忽略不可用的索引，并且在创建 7 天后过期。
PUT _slm/policy/prod_cluster_daily_backups
{
  "name":"<prod_daily_backups-{now/d}>",
  "schedule": "0 0 0 * * ?",
  "repository": "es_cluster_snapshot_repository",
  "config": {
    "indices":["*movies*", "*reviews*"],
    "include_global_state": false,
    "ignore_unavailable": false
  },
  "retention":{
    "expire_after":"7d"
  }
}

# 立即执行 "prod_cluster_daily_backups" 策略，创建一个快照。
POST _slm/policy/prod_cluster_daily_backups/_execute
```

### 关闭无关的功能

在 Elasticsearch 中，有一些设置可以帮助你关闭不需要的功能，以优化性能和存储使用。以下是你提到的一些设置的解释：

- **Index 设置为 false**：如果你只需要对字段进行聚合，而不需要对其进行搜索，你可以将该字段的 `index` 设置为 `false`。这意味着 Elasticsearch 不会为该字段创建倒排索引，从而节省存储空间。

- **Norms 设置为 false**：`norms` 是用于评分的一种数据结构。如果你不需要对搜索结果进行评分，你可以将 `norms` 设置为 `false`，以节省存储空间。

- **避免对字符串使用默认的 dynamic mapping**：默认的 dynamic mapping 可能会为字符串字段创建多余的索引和 norms。如果你的文档包含大量的字符串字段，这可能会导致性能问题。你可以通过自定义 mapping 来避免这个问题。

- **Index_options**：`index_options` 控制在创建倒排索引时，哪些内容会被添加到倒排索引中。通过优化这个设置，你可以节省 CPU 资源。

- **关闭 \_source**：`_source` 字段包含了文档的原始 JSON 表示。如果你不需要这个功能，你可以将 `_source` 设置为 `false`，以节省存储空间。但是请注意，关闭 `_source` 会使你无法执行某些操作，例如 update 和 reindex。

以上的设置都可以在创建索引时指定，也可以在索引创建后通过 `_mapping` API 进行修改。但是请注意，修改已存在的字段的设置可能需要重新索引数据。

## 优化集群读性能

- **数据非规范化**：尽可能地对数据进行非规范化，以提高查询性能。避免使用 Nested 类型（慢几倍）和 Parent/Child 关系（慢几百倍），这些复杂的数据结构会降低查询速度。
- **预计算数据**：尽量将数据先行计算，然后保存到 Elasticsearch 中，避免查询时的 Script 计算。
- **利用 Filter Context**：尽量使用 Filter Context，利用缓存机制，减少不必要的算分。
- **分析慢查询**：结合 profile 和 explain API 分析慢查询的问题，持续优化数据模型。
- **避免使用通配符**：避免使用以 \* 开头的通配符，这会导致 Elasticsearch 扫描所有的字段，影响性能。

### 缓存

Elasticsearch 使用了多种缓存策略来提高查询性能，包括：

- **[Node Query Cache](https://www.elastic.co/guide/en/elasticsearch/reference/current/query-cache.html)**：

  - 由节点上的所有 shard 共享的。
  - 只缓存 Filter Context 中的查询结果。
  - 使用 LRU（Least Recently Used）算法来决定何时清除缓存
  - 通过 `indices.queries.cache.size` 和 `index.queries.cache.enabled` 来配置。
  - 保存的是 Segment 级缓存命中的结果。Segment 被合并后，缓存会失效

- **[Shard Request Cache](https://www.elastic.co/guide/en/elasticsearch/reference/current/shard-request-cache.html)**：

  - 缓存每个 shard 上的查询结果。它只会缓存设置了 size=0 的查询对应的结果，这种查询通常用于计数或聚合，而不是获取具体的文档。
  - 整个 JSON 查询串作为 Key，这意味着缓存的键与 JSON 对象的顺序相关。
  - 通过 `indices.requests.cache.size` 参数来设置。
  - 分片 Refresh 时候， Shard Request Cache 会失效。如果 Shard 对应的数据频繁发生变化，该缓存的效率会很差。

- **[Field Data Cache](https://www.elastic.co/guide/en/elasticsearch/reference/current/modules-fielddata.html)**：

  - 除了 Text 类型的字段，默认都采用 doc_values 来存储字段数据，这样可以节约内存。Aggregation 的 Global ordinals 也保存在 Field Data Cache 中。
  - Text 类型的字段需要打开 Fielddata 才能对其进行聚合和排序。但是，由于 Text 类型的字段经过分词，排序和聚合效果不佳，因此建议不要轻易使用。
  - 通过 `indices.fielddata.cache.size` 参数来设置。
  - Segment 被合并后，会失效。

## 容量规划

案例 1：每天 1GB 的数据，一个索引一个主分片，一个副本分片需保留半年的数据，接近 360 GB 的数据量。
案例 2：5 个不同的日志，每天创建一个日志索引。每个日志索引创建 10 个主分片保留半年的数据 $5 \times 10 \times 30 \times 6 = 9000$ 个分片

[分片大小建议](https://www.elastic.co/guide/en/elasticsearch/reference/current/size-your-shards.html#shard-size-recommendation)

- 日志类应用，单个分片不要大于 50 GB
- 搜索类应用，单个分片不要超过 20 GB

在确定节点的内存大小时，需要根据节点需要存储的数据量来进行估算。可用内存一半分配给 JVM，一半留给操作系统，缓存索引文件。

- 对于搜索类的项目，建议内存与存储的比例为 1:16。
- 对于日志类的项目，建议内存与存储的比例在 1:48 到 1:96 之间。

总数据量 1T，设置一个副本 = 2T 总数据量

- 对于搜索类的项目，每个节点可以存储的数据量是 $31 \times 16 = 496G$。但是，为了预留一些空间，实际上每个节点最多存储 400G 的数据。因此，如果总数据量是 2T（即 2000G），那么至少需要 5 个数据节点。
- 对于日志类的项目，每个节点可以存储的数据量是 $31 \times 50 = 1550GB$。因此，如果总数据量是 2T（即 2000G），那么只需要 2 个数据节点就足够了。

以下是一些 Elasticsearch 存储的最佳实践：

- 存储极客推荐使用 SSD，因为它们提供了更快的读写速度。
- 使用本地存储（Local Disk），避免使用 SAN、NFS、AWS 或 Azure 文件系统。这是因为本地存储通常提供更好的性能和可靠性。
- Elasticsearch 允许在本地指定多个“path.data”，以支持使用多块磁盘。这可以帮助提高存储容量和性能。
- Elasticsearch 本身提供了很好的高可用性（HA）机制，因此无需使用 RAID 1/5/10。
- 在 Warm 节点上可以使用 Spinning Disk，但是需要关闭 Concurrent Merges，即将 `index.merge.scheduler.max_thread_count` 设置为 1。
- 定期执行 SSD 的 [Trim](https://www.elastic.co/blog/is-your-elasticsearch-trimmed) 操作，以保持其最佳性能。

## [Circuit breaker](https://www.elastic.co/guide/en/elasticsearch/reference/current/circuit-breaker.html)

Elasticsearch 提供了多种 Circuit Breaker，用于防止某些操作使用过多的 JVM 堆内存，从而导致 OutOfMemoryError。以下是一些主要的 Circuit Breaker：

1. **Parent Circuit Breaker**：这是所有其他 Circuit Breaker 的父级，它的阈值是所有子级 Circuit Breaker 阈值的总和。

2. **Field Data Circuit Breaker**：用于限制 Field Data 的内存使用。

3. **Request Circuit Breaker**：用于限制单个请求的内存使用。

4. **In Flight Requests Circuit Breaker**：用于限制当前正在处理的所有请求的内存使用。

5. **Accounting Circuit Breaker**：用于限制 Lucene 段（Segment）的内存使用。

6. **Script Compilation Circuit Breaker**：用于限制脚本编译的内存使用。

7. **Regex Circuit Breaker**：用于限制正则表达式操作的内存使用。

8. **EQL Circuit Breaker**：用于限制 Event Query Language (EQL) 的内存使用。

9. **Machine Learning Circuit Breaker**：用于限制机器学习作业的内存使用。

每种 Circuit Breaker 都有自己的阈值，当内存使用接近阈值时，Elasticsearch 会阻止执行可能导致 OutOfMemoryError 的操作。

## Cases

### Segments 个数过多，导致 full GC

**问题**：集群整体响应变慢，尽管没有特别多的数据读写。但是发现节点在持续进行 Full GC。

**分析**：查看 Elasticsearch 的内存使用，发现 segments.memory 占用很大空间

**解决**： 通过 force merge，把 segments 合并成一个。

**建议**：对于不再写入和更新的索引，将其设置为只读并执行 force merge 操作可以有效地减少内存占用和 GC 压力。如果问题仍然存在，那么可能需要考虑扩容 Elasticsearch 集群。此外，force merge 操作还可以减少对 global_ordinals 数据结构的构建，从而减少对 field data cache 的开销。

### Field data cache 过大，导致 full GC

**问题**：集群整体响应缓慢，尽管没有大量的数据读写活动，但节点持续进行 Full GC。

**分析**：发现 Elasticsearch 的内存使用中 fielddata.memory.size 占用很大空间，并且数据不存在写入和更新，并且已经执行过 segments merge

**解决**：将 `indices.fielddata.cache.size` 设置为较小的值，并且在重启节点后，堆内存恢复正常。

**建议**：Field data cache 在 Elasticsearch 中的构建相对比较消耗资源，并且 Elasticsearch 不会主动释放它。因此，确保将 Field data cache 的大小设置得适度是很重要的，以避免过多的内存使用。

### 复杂的嵌套聚合，导致集群 full GC

**问题**：节点响应缓慢，持续进行 Full GC

**分析**：导出 Dump 分析。发现内存中有大量 bucket 对象，查看日志，发现复杂的嵌套聚合

**解决**：优化聚合

**建议**：在大量数据集上进行嵌套聚合查询确实需要大量的堆内存。如果业务场景确实需要这样的查询，那么可能需要增加硬件进行扩展。同时，为了避免这类查询影响整个集群，可以设置 Circuit Breaker 和 search.max_buckets 的数值。
