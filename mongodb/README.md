## 基本概念

以下是 [MongoDB vs MySQL](https://www.mongodb.com/docs/manual/reference/sql-comparison/) 的基本概念对比：

|  MongoDB   |  MySQL   |
| :--------: | :------: |
|  Database  | Database |
| Collection |  Table   |
|  Document  |   Row    |
|   Field    |  Column  |
|    BSON    |  Schema  |
|    MQL     |   SQL    |

## [数据类型](https://www.mongodb.com/docs/manual/reference/bson-types/)

MongoDB 使用 BSON（Binary JSON）格式来存储数据，BSON 支持的数据类型如下：

1. **Double**：双精度浮点数。

2. **String**：字符串。

3. **Object**：嵌套的文档。

4. **Array**：数组或列表。

5. **Binary data**：二进制数据。

6. **Undefined**：未定义，已废弃。

7. **ObjectId**：文档 ID。

8. **Boolean**：布尔值。

9. **Date**：日期。

10. **Null**：空值。

11. **Regular Expression**：正则表达式。

12. **DBPointer**：数据库指针，已废弃。

13. **JavaScript**：存储 JavaScript 代码。

14. **Symbol**：符号，已废弃。

15. **32-bit integer**：32 位整数。

16. **Timestamp**：时间戳。

17. **64-bit integer**：64 位整数。

18. **Decimal128**：128 位十进制数。

19. **Min key**：最小键。

20. **Max key**：最大键。

## 数据建模

### [建模类型](https://www.mongodb.com/blog/post/building-with-patterns-a-summary)

- **Attribute Pattern（属性模式）**：通过将==多个列（field）组织为键值对数组==，优化了对具有共同特性字段的查询和排序，使得索引更加高效，查询更加简单和快速。
- **Schema Versioning（模式版本控制模式）**：通过为文档添加 `schema_version` 字段来支持不同版本的 schema 共存于同一个集合中的模式设计模式。
- **Subset（子集模式）**：将文档中经常访问的数据和不常访问的数据分离存储在不同集合中的模式，目的是减小工作集大小，提高常用数据的访问效率。
- **Approximation（近似值模式）**：在应用程序中对不需要高精度、计算代价昂贵的数据使用近似值而不是精确值的模式设计模式，目的是减少数据库写入操作，从而提高性能。
- **Preallocated（预分配模式）**：预先为文档分配空结构或数组，尽管暂时不完全利用，但能简化代码并提高某些操作的性能，代价是增加了内存占用。
- **Bucket（分桶模式）**：将时间序列数据根据时间段进行分组存储在同一文档中的模式，通过预计算和存储聚合结果，可以降低索引大小、简化查询并提高分析性能。
- **Polymorphic（多态模式）**：在同一个集合中存储结构相似但不完全相同的文档，以便能够对整个集合执行查询操作。
- **Computed（计算模式）**：预先计算和存储需要重复计算的数据的模式，目的是减轻 CPU 负载，提高应用程序性能。

## CRUD

### [Read Preference](https://www.mongodb.com/docs/manual/core/read-preference/)

在 MongoDB 中，`readPreference` 是决定了驱动程序或 mongos ==从哪个成员（或成员集）读取数据==。这个设置可以在多个级别进行配置，包括客户端、数据库、集合或操作级别。

`readPreference` 有以下几种选项：

1. **primary**：这是默认的 `readPreference`。所有的读操作都会发送到复制集的主节点。如果主节点不可用，那么读操作将会失败。

2. **primaryPreferred**：在大多数情况下，读操作会发送到复制集的主节点。但是，如果主节点不可用，读操作会发送到复制集的一个副本节点。

3. **secondary**：所有的读操作都会发送到复制集的一个副本节点。如果没有副本节点可用，那么读操作将会失败。

4. **secondaryPreferred**：在大多数情况下，读操作会发送到复制集的一个副本节点。但是，如果没有副本节点可用，读操作会发送到复制集的主节点。

5. **nearest**：读操作会发送到网络延迟最小的节点，无论它是主节点还是副本节点。

`readPreference` 的选择取决于你的应用程序的需求。例如，如果你的应用程序需要最新的数据，你应该选择 `primary`。如果你的应用程序需要高可用性，你可以选择 `primaryPreferred` 或 `secondaryPreferred`。如果你的应用程序需要低延迟，你可以选择 `nearest`。

### [Read Concern](https://www.mongodb.com/docs/manual/reference/read-concern/)

Read Concern 用于指定读取操作（如查询）应返回的数据的版本。Read Concern 可以控制数据的一致性和隔离性。

Read Concern 的主要参数包括：

- `level`：此选项指定了读取操作应返回的数据的版本。
  - `local`：返回本地副本集成员的数据。这是默认的 Read Concern 级别。
  - `available`：对于非分片集合，此级别与 `local` 相同。对于分片集合，此级别将返回任何数据，不管数据是否可能反映最新的成功写入操作。
  - `majority`：返回已经复制到大多数副本集成员的数据。
  - `linearizable`：确保返回的数据反映了所有成功写入操作的最新状态。需要在网络中的所有副本集成员之间进行一致性检查。此级别只适用于对单个文档的读取操作。
  - `snapshot`：返回在同一时间点捕获的数据的快照。此级别只在分布式事务中可用。

### [Write Concern](https://www.mongodb.com/docs/manual/reference/write-concern/)

Write Concern 用于指定在写操作（如插入、更新或删除）被视为成功之前，必须满足的数据持久性和数据复制的条件。

Write Concern 的主要参数包括：

- `w`：此选项指定了数据需要被写入的副本集成员数量。例如，`w: 1` 表示数据至少需要被写入一个副本集成员。

  - 从 MongoDB 5.0 版本开始，默认的 write concern 是 `{ w: "majority" }`

    但如果部署中包含仲裁节点，并且数据承载投票节点数不大于投票节点多数，那么默认的 write concern 是 `{ w: 1 }`

- `j`：如果设置为 `true`，则写操作将等待 MongoDB 将数据写入磁盘的日志文件，以确保在 MongoDB 实例崩溃的情况下，数据不会丢失。

  - 如果 `writeConcernMajorityJournalDefault=true` (默认值)， 那么 `{ w: "majority" }` 写关注点隐含 `{ j: true }`

    如果 `writeConcernMajorityJournalDefault=false`， 那么 `{ w: "majority" }` 写关注点隐含 `{ j: false }`

- `wtimeout`：此选项指定了等待写操作完成的时间（以毫秒为单位）。如果写操作在这个时间内未完成，MongoDB 将停止等待，但不会回滚已经完成的数据写入。选项默认情况下是未设置的，相当于没有超时限制。

### Tag

Tag 是一种用于对数据库集群中节点或数据进行分类和标记的机制。

**ReplicaSet:**

- 读取偏好 (Read Preference): 根据 Tag 集指定读操作定向到具有特定标签的成员。
- 自定义写关注 (Custom Write Concern): 基于标签设置写操作需要在哪些标记成员上得到确认。

**Sharding:**

- 将数据根据标签进行区域化或地理位置感知分布。
- 通过为分片设置标签，可将特定数据限制在某些分片上。
- 针对具有特定标签的分片设置查询或写操作的偏好。

因此，在 ReplicaSet 中，Tag 主要用于读写操作的路由和约束；而在 Sharded Cluster 中，Tag 则用于控制数据的物理分布位置，使某些数据位于具有特定标签的分片上，还可为这些分片数据设置操作偏好。

### [Connection Strings](https://www.mongodb.com/docs/manual/reference/connection-string/)

连接字符串可以用于定义 MongoDB 实例与以下目标之间的连接：

- 当您使用驱动程序连接时，连接字符串可以连接您的应用程序。
- 连接字符串可以连接工具，如 MongoDB Compass 和 MongoDB Shell（mongosh）。

## 事务

## [Change Streams](https://www.mongodb.com/docs/manual/changeStreams/)

MongoDB 的 Change Streams 是一种允许应用程序访问实时数据库更改的功能。它们可以在集合、数据库或整个部署（包括分片集群）级别打开，可以订阅所有数据更改并立即对其做出反应。由于 Change Streams 使用了聚合框架，应用程序还可以过滤特定的更改或按需转换通知。

从 MongoDB 5.1 开始，Change Streams 进行了优化，提供了更高效的资源利用和某些聚合管道阶段的更快执行。

Change Streams 可用于副本集和分片集群，但需要满足以下条件：

- 存储引擎：副本集和分片集群必须使用 WiredTiger 存储引擎。Change Streams 也可以在使用了 MongoDB 的数据在静态加密特性的部署中使用。
- 副本集协议版本：副本集和分片集群必须使用副本集协议版本 1（pv1）。
- "majority" 读取关注（read concern）的启用：从 MongoDB 4.2 开始，无论是否支持 "majority" 读取关注，Change Streams 都可用。在 MongoDB 4.0 及更早版本中，只有在启用了 "majority" 读取关注（默认启用）时，Change Streams 才可用。

可以在集合、数据库或整个部署（副本集或分片集群）上打开 Change Streams，以监视所有非系统集合的更改（排除 admin、local 和 config 数据库）。

## [Time Series](https://www.mongodb.com/docs/manual/core/timeseries-collections/)

## [索引](https://www.mongodb.com/docs/manual/indexes/)

索引类型（Index Types）：索引可以用于哪种类型的查询。

- **单字段索引（Single Field Indexes）**：在一个字段上创建索引。
- ==**复合索引（Compound Indexes）**==：在多个字段上创建索引，以支持多字段的查询。
  - ESR 原则：在创建组合索引时，将等式条件的字段放在前面，排序字段放在中间，范围条件的字段放在后面，以提高查询效率。
- **多键索引（Multikey Indexes）**：用于数组数据。MongoDB 会为数组中的每个元素创建索引。
- **文本索引（Text Indexes）**：支持在包含字符串内容的字段上进行文本搜索查询的索引类型，它可以提高搜索特定单词或短语的性能，每个集合只能有一个文本索引，但该索引可以覆盖多个字段。
- **通配符索引（Wildcard Indexes）**：可以在文档的任何字段上创建索引。
- **地理空间索引（Geospatial Indexes）**：用于地理空间查询。
- **哈希索引（Hashed Indexes）**：用于支持分片。

索引属性（Index Properties）描述了索引的特定行为或特性。

- **大小写不敏感索引（Case-Insensitive Indexes）**：允许你在查询时忽略字段值的大小写。

- **隐藏索引（Hidden Indexes）**：不会被查询优化器用于查询计划，但仍然会接收写操作。

- **部分索引（Partial Indexes）**：只包含满足过滤条件的文档，可以减少索引的大小和提高写操作的性能。

- **稀疏索引（Sparse Indexes）**：只包含存在索引字段的文档，对于不存在索引字段的文档，不会在索引中创建条目。

- **TTL 索引（TTL Indexes）**：这种索引允许你设置文档的生存时间，MongoDB 会自动删除过期的文档。

- **唯一索引（Unique Indexes）**：强制字段值的唯一性，不允许插入具有相同索引字段值的文档。

## 部署架构

### [副本集](https://www.mongodb.com/docs/manual/replication/)

![](https://www.mongodb.com/docs/manual/images/replica-set-primary-with-two-secondaries.bakedsvg.svg)

#### 副本集的角色

- **Primary**：副本集中的主节点，负责处理所有的写操作。在一个副本集中，任何时候只能有一个主节点。
- **Secondary**：副本集中的从节点，可以处理读操作（如果配置允许），并复制主节点的数据。在一个副本集中，可以有多个从节点。
- **Arbiter**：仲裁者节点，不存储数据，只参与选举过程。当主节点和从节点的投票数相同时，仲裁者可以参与投票以决定新的主节点。

#### 复制过程

1. 当主节点（Primary）上发生写操作（如插入、更新或删除）时，这些操作会被记录到操作日志（oplog）中。

2. 从节点（Secondary）会定期从主节点的 oplog 中拉取新的操作。

3. 从节点在本地回放这些操作，以更新自己的数据集。

4. 如果从节点与主节点断开连接一段时间，然后重新连接，它会尝试从断开连接时的 oplog 位置开始复制。如果这部分 oplog 已经被主节点清除，从节点会再次执行初始同步。

5. 如果主节点出现故障，副本集会自动进行选举，选出新的主节点。新的主节点会开始接收写操作，并记录到 oplog 中，从节点则继续从新的主节点复制操作。

#### [选举过程](https://www.mongodb.com/docs/manual/core/replica-set-elections/)

1. **触发选举**：副本集可以因为多种事件触发选举，例如添加新节点到副本集，初始化副本集，使用如 rs.stepDown() 或 rs.reconfig() 等方法进行副本集维护，以及从节点失去与主节点的连接超过配置的超时时间（默认为 10 秒）。
2. **心跳检测**：副本集中的成员会定期进行心跳检测，以检查其他成员的状态。如果一个成员在一定时间内（默认为 10 秒）没有响应心跳请求，那么该成员将被视为不可达。
3. **发起选举**：如果主节点变得不可达，剩余的副本集成员会发起选举以选出新的主节点。只有具有投票权的成员才能参与选举。
4. **选举过程**：在选举过程中，每个成员都会投票给它认为最适合成为主节点的成员。在 MongoDB 中，最适合成为主节点的通常是数据最新的成员。影响选举的因素有以下几点：

   1. **节点的投票权**：只有具有投票权的成员才能参与选举。
   2. **节点的数据同步状态**：数据最新的节点更有可能被选为主节点。
   3. **节点的优先级**：优先级高的节点更有可能被选为主节点。

5. **选举成功**：当一个成员获得大多数投票时，它将被选为新的主节点。然后，该成员将开始接收写操作，并将这些操作复制到其他副本集成员。
6. **故障恢复**：新的主节点选举成功后，副本集就完成了故障恢复。客户端可以继续向新的主节点发送读写请求。

#### 常用成员配置选选项

1. **[投票权（`votes` 参数）](https://www.mongodb.com/docs/manual/reference/replica-configuration/#mongodb-rsconf-rsconf.members-n-.votes)**：默认情况下，每个副本集成员都有投票权，可以参与选举。但是，可以通过设置 `votes` 参数为 0 来使一个成员失去投票权。
2. **[优先级（`priority` 参数）](https://www.mongodb.com/docs/manual/reference/replica-configuration/#mongodb-rsconf-rsconf.members-n-.priority)**：这个参数决定了一个成员被选为主节点的优先级。数值越高，优先级越高。如果设置为 0，该成员将永远不会被选为主节点。
3. **[隐藏（`hidden` 参数）](https://www.mongodb.com/docs/manual/reference/replica-configuration/#mongodb-rsconf-rsconf.members-n-.hidden)**：复制主节点的数据，但对客户端应用程序是不可见的。优先级为 0 的成员，可以在副本集选举中投票和确认写关注（Write Concern）。

### [分片](https://www.mongodb.com/docs/manual/sharding/)

在 MongoDB 的分片架构中，主要有以下概念：

1. **Shard**：存储数据的节点或副本集。在分片集群中，数据被分布在多个 shard 上。

2. **Mongos**：路由进程，接收客户端的请求并将其路由到适当的 shard。客户端不直接与 shard 交互，而是通过 mongos。

3. **Config Server**：存储集群的元数据和配置信息。在生产环境中，通常使用一个副本集作为配置服务器，以提供冗余和数据一致性。

![](https://www.mongodb.com/docs/manual/images/sharded-cluster-production-architecture.bakedsvg.svg)

4. **[Shard Key](https://docs.mongodb.com/manual/core/sharding-shard-key/)**：分片键是用于确定数据如何在集群中分布的字段或字段集合。MongoDB 根据分片键的值将数据分配到不同的分片。选择一个好的分片键是实现有效分片的关键，因为它影响到数据的分布均匀性和查询的效率。

   1. 分片键基数（Cardinality）：尽量选择基数较高的键作为分片键，这样可以最大化创建的分片数量，提高集群的水平扩展能力。

   2. 分片键值频率：避免选择在数据中高频出现的键作为分片键。（热点）

   3. 单调变化分片键：避免选择单调递增或递减的键作为分片键，因为这种情况下新插入都会路由到同一个分片，导致数据分布不均。对于这种情况，可以考虑使用哈希分片。

   4. 复合分片键：如果单个键不满足要求，可以考虑使用复合分片键来提高基数或覆盖更多查询模式。

   5. 分片键不可变性（自 MongoDB 4.2 开始）MongoDB 4.2 及更早版本不允许修改已分片集合的分片键，4.2 版本开始如果分片键不是`_id`字段则允许修改。

5. **[Chunks](https://docs.mongodb.com/manual/core/sharding-chunk-splitting/)**：在 Sharding 中，数据被分割成大小相等的块，这些块被称为 chunk。每个 chunk 包含一定范围的分片键值。MongoDB 会根据 chunk 的大小自动分割和合并 chunk，以保持数据的均匀分布。

6. **[Balancer](https://www.mongodb.com/docs/manual/core/sharding-balancer-administration/)**：Balancer 是 MongoDB 分片的一个组件，负责在集群中平衡 chunk。当某个分片的 chunk 数量超过其他分片时，Balancer 会将 chunk 从该分片迁移到其他分片，以保持各个分片的数据量大致相等。

![sharding-range-based](https://www.mongodb.com/docs/manual/images/sharding-range-based.bakedsvg.svg)



#### 分片集群数据分布方式

1. **[基于范围（Range-based sharding）](https://www.mongodb.com/docs/manual/core/ranged-sharding/)**：数据被分配到不同的分片中，每个分片负责一个特定的键值范围。例如，用户 ID 1-1000 可能在分片 A 上，用户 ID 1001-2000 可能在分片 B 上。这种方式的优点是查询可以定向到特定的分片，但缺点是如果数据分布不均，可能会导致某些分片的负载过重。

2. **[基于哈希（Hash-based sharding）](https://www.mongodb.com/docs/manual/core/hashed-sharding/)**：分片键的值被哈希处理，然后根据哈希值分配到不同的分片。这种方式的优点是数据分布更均匀，但缺点是范围查询的效率较低，因为可能需要查询所有的分片。

3. **基于区域/标签（Zone/Tag-based sharding）**：数据被分配到不同的分片，每个分片负责一个或多个预定义的区域或标签。这种方式的优点是可以根据业务需求灵活地控制数据的分布，例如，可以将某个地区的用户数据分配到同一分片，以优化地理位置相关的查询。

在 MongoDB 分片中，从大到小的概念是：

1. 集群（Cluster）是包含多个 Shard
2. 分片（Shard）是包含多个 Chunk
3. 块（Chunk）是包含多个 Document
4. 文档（Document）是包含分片键的一行数据
5. 分片键（Shard Key）是文档中的一个字段（主键）

#### 容量设计

容量设计主要考虑存储容量、内存容量和并发数。

- [$bsonSize](https://www.mongodb.com/docs/manual/reference/operator/aggregation/bsonSize/)：可用于计算文档大小，帮助评估存储容量需求。

- [collStats.indexSizes](https://www.mongodb.com/docs/manual/reference/command/collStats/#mongodb-data-collStats.indexSizes)：用于获取集合中索引的大小信息，有助于评估索引对存储空间的占用情况。

查看更多相关信息，请参阅 [Aliyun 性能白皮书](https://help.aliyun.com/zh/mongodb/support/performance-white-paper/)。
