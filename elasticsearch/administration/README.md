## 重建索引

在 Elasticsearch 中，以下是一些可能需要重建索引的情况：

1. **映射更改**：如果你需要更改现有字段的类型或者添加新的字段到现有的映射中，你需要重建索引。在 Elasticsearch 中，一旦字段被索引，其类型就不能更改。
2. **分片数量更改**：如果你需要更改索引的分片数量，你需要重建索引。在 Elasticsearch 中，一旦索引被创建，其分片数量就不能更改。
3. **优化性能**：如果你需要优化查询性能，例如更改分词器或优化文档结构，你可能需要重建索引。
4. **删除旧数据**：如果你需要删除大量的旧数据，重建索引可能比删除单个文档更高效。
5. **升级 Elasticsearch 版本**：在某些情况下，升级 Elasticsearch 到新版本可能需要重建索引。

请注意，重建索引可能会消耗大量的计算资源，并可能导致服务中断，因此在进行重建索引操作时需要谨慎。

## 参考

- https://www.elastic.co/guide/en/elasticsearch/reference/current/size-your-shards.html#shard-size-recommendation
