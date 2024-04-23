## 控制文档的 ID

在 Elasticsearch 中，每个被索引的文档都可以有一个标识符（ID），通常由用户指定。这个 ID 类似于关系数据库中的主键，一旦与文档关联，就会在文档的生命周期内保持不变（除非用户有意改变它）。

- 如果客户端提供了文档的 ID，我们使用 HTTP **PUT 方法**调用文档 API 来索引该文档。使用 PUT 方法必须带有文档 ID，否则会报错。
- 如果客户端没有提供文档的 ID，我们在索引时使用 HTTP **POST 方法**。在这种情况下，一旦文档被索引，它将继承系统生成的 ID。

那何时使用 PUT/POST 方法呢？

如果你想要控制文档的 ID 或者你已经知道文档的 ID，你应该使用 PUT 方法来索引文档。这些文档可以是你的领域对象，它们有预定义的身份策略（如主键）。如果你知道文档的 ID，你可以使用文档 API 来获取文档。

对于源自流数据或时间序列事件的文档，使用 ID 可能没有意义（比如来自定价服务器的价格报价，股价波动，来自云服务的系统警报，推文，或自动驾驶汽车的心跳）。对于这些事件和消息，有一个随机生成的 UUID 就足够了。在这种情况下，你应该使用 POST 方法来索引文档。

```json
# 创建一个电影文档带有 ID
PUT movies/_doc/1
{
  "title":"The Godfather",
  "synopsis":"The aging patriarch of an organized crime dynasty transfers control of his clandestine empire to his reluctant son"
}

# 创建一个文档不带 ID
POST movies_reviews/_doc
{
  "movie":"The Godfather",
  "user":"Peter Piper",
  "rating":4.5,
  "remarks":"The movie started with a ..."
}

# 创建一个文档带有 ID
POST movies/_doc/1
{
  "movie":"The Godfather"
}
```

## 使用 `_create` 避免覆盖文档

```json
# 会覆盖文档
PUT movies/_doc/1
{
  "tweet":"Elasticsearch in Action 2e is here!"
}

# 使用 _create 避免重写文档
PUT movies/_create/100
{
  "title":"Mission: Impossible",
  "director":"Brian De Palma"
}
PUT movies/_create/100
{
  "tweet":"A movie with popcorn is so cool!"
}
```

## 文档存储原理

![Mechanics of indexing documents](https://image.linux88.com/2024/04/23/edde42db56a375b94a60efe7ffe4de69.svg)

Elasticsearch 文档存储机制的主要步骤如下：

1. 当索引一个文档时，引擎会根据路由算法决定该文档将被存储在哪个分片中。每个分片都是 Lucene 实例，它们持有与索引逻辑相关的物理数据。
2. 每个分片都有一部分堆内存，当文档被索引时，文档首先被推送到分片的内存缓冲区。
3. 文档在内存缓冲区中保持，直到发生刷新。Lucene 的调度器每秒发出一次刷新，收集内存缓冲区中的所有文档，然后用这些文档创建一个新的段。
4. 段由文档数据和倒排索引组成。数据首先被写入文件系统缓存，然后提交到物理磁盘。
5. Lucene 避免了频繁的 I/O 操作。因此，它等待刷新间隔（一秒），之后，文档被打包推送到段中。
6. 一旦文档被移动到段中，它们就可以被搜索。
7. Lucene 在处理数据写入和读取时非常智能。在将文档推送到新段（在刷新操作期间）后，它会等待形成三个段。它使用三段合并模式来合并段以创建新段：每当有三个段准备好时，Lucene 就会通过合并它们来实例化一个新的段。
8. 在一秒的刷新间隔内，会创建一个新的段来保存在内存缓冲区中收集的所有文档。分片的堆内存（Lucene 实例）决定了它可以在将它们刷新到文件存储之前在内存缓冲区中保存多少文档。
9. 在所有实际应用中，Lucene 将段视为不可变资源。也就是说，一旦用缓冲区中的可用文档创建了一个段，就不会有新的文档进入这个现有的段。相反，它们会被移动到一个新的段。
10. 同样，删除操作不会在段中的文档上物理执行，而是标记文档以便稍后删除。Lucene 采用这种策略以提供高性能和吞吐量。

### [Refresh](https://www.elastic.co/guide/en/elasticsearch/reference/current/docs-refresh.html)

当新的文档被索引时，它们首先被保存在 Index Buffer 中。然后，以 `refresh_interval` 为间隔，Elasticsearch 会定期清空 Index Buffer，生成新的 Segment，并将这些 Segment 放入文件系统缓存中，同时使这些新的文档可被搜索。这个过程被称为 Refresh。Refresh 的目的是提高搜索的实时性，但是它并不会将数据持久化到磁盘。

- 降低 Refresh 的频率：你可以通过增加 refresh_interval 的值来降低 Refresh 的频率。例如，你可以将 refresh_interval 设置为 5s，这样每 5 秒才会进行一次刷新。
- 增大 `indices.memory.index_buffer_size`：`indices.memory.index_buffer_size` 是控制索引缓冲区大小的参数。如果这个参数的值过小，可能会导致频繁的 Refresh。你可以尝试增大这个参数的值，以减少 Refresh 的频率。默认值是 JVM 堆大小的 10%。

**服务端刷新控制**

```json
PUT movies/_settings
{
  "index": {
    "refresh_interval": "30s"
  }
}
```

**客户端刷新控制**

文档 API（index、delete、update 和 bulk）期望刷新作为查询参数。

```json
# 告诉引擎不强制刷新操作，而是应用默认设置（一秒）。
PUT movies/_doc/1?refresh=false

# 即时的搜索结果，但可能会对性能产生影响，因为每个操作都会触发刷新。
PUT movies/_doc/1?refresh=true

# 证搜索结果的准确性和提高性能之间找到了平衡，因为它只在刷新周期内阻塞请求，而不是每个操作都触发刷新。
PUT movies/_doc/1?refresh=wait_for
```

### Translog

为了在系统崩溃后能够恢复数据，Elasticsearch 会将每个索引操作写入到 Translog 中。即使 Segment 还没有被写入到磁盘，只要操作已经被写入到 Translog，就可以在系统重启后恢复数据。默认情况下，每个索引请求都会写入到 Translog，并且在请求返回前被 fsync 到磁盘。

- **降低写磁盘的频率**：你可以通过修改 `index.translog.durability` 的值来降低写磁盘的频率。默认情况下，这个参数的值是 `request`，这意味着每个请求都会写入到磁盘。如果你将这个参数的值设置为 `async`，那么写入磁盘的操作将会是异步的，这可以提高性能，但是可能会降低数据的安全性。

- **修改同步间隔**：你可以通过修改 `index.translog.sync_interval` 的值来控制同步到磁盘的频率。例如，你可以将这个参数的值设置为 `30s`，这样每分钟才会同步一次到磁盘。

- **调整 Flush 阈值**：`index.translog.flush_threshold_size` 是控制何时触发 Flush 的参数。默认情况下，这个参数的值是 `512mb`。当 Translog 的大小超过这个值时，Elasticsearch 会触发一个 Flush 操作。你可以尝试增大这个参数的值，以减少 Flush 的频率。

```json
PUT /my_index/_settings
{
  "index" : {
    "translog.durability" : "async",
    "translog.sync_interval" : "30s",
  }
}
```

### Flush

Flush 是一个更重的操作，它包括将当前的 Index Buffer 写入到新的 Segment，将新的 Segment fsync 到磁盘，清空 Translog，并将新的 commit point 写入到磁盘。Flush 会确保所有的数据都被持久化到磁盘，这样即使发生系统崩溃，也不会丢失任何数据。Elasticsearch 会自动执行 Flush 操作，但是你也可以手动触发 Flush。
