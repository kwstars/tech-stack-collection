在 Elasticsearch 中，删除（Delete）操作主要有以下几种方式：

1. `Delete API`：Delete API 用于删除指定 ID 的文档。详细信息可以在 Elasticsearch 官方文档中找到：[Delete API](https://www.elastic.co/guide/en/elasticsearch/reference/current/docs-delete.html)

2. `Delete By Query API`：Delete By Query API 允许你删除满足查询条件的所有文档。详细信息可以在 Elasticsearch 官方文档中找到：[Delete By Query API](https://www.elastic.co/guide/en/elasticsearch/reference/current/docs-delete-by-query.html)

3. `Bulk API`：Bulk API 允许在单个请求中执行多个索引/删除操作，这可以大大提高删除速度。详细信息可以在 Elasticsearch 官方文档中找到：[Bulk API](https://www.elastic.co/guide/en/elasticsearch/reference/current/docs-bulk.html)
