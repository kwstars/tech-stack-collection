在 Elasticsearch 中，更新（Update）操作主要有以下几种方式：

1. `Update API`：Update API 允许你更新现有文档的部分内容。详细信息可以在 Elasticsearch 官方文档中找到：[Update API](https://www.elastic.co/guide/en/elasticsearch/reference/current/docs-update.html)

2. `Bulk API`：Bulk API 允许在单个请求中执行多个索引/更新/删除操作，这可以大大提高更新速度。详细信息可以在 Elasticsearch 官方文档中找到：[Bulk API](https://www.elastic.co/guide/en/elasticsearch/reference/current/docs-bulk.html)

3. `Update By Query API`：Update By Query API 允许你更新满足查询条件的所有文档。详细信息可以在 Elasticsearch 官方文档中找到：[Update By Query API](https://www.elastic.co/guide/en/elasticsearch/reference/current/docs-update-by-query.html)
