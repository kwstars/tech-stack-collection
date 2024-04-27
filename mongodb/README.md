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

### [readPreference](https://www.mongodb.com/docs/manual/core/read-preference/)

在 MongoDB 中，`readPreference` 是决定了驱动程序或 mongos 从哪个成员（或成员集）读取数据。这个设置可以在多个级别进行配置，包括客户端、数据库、集合或操作级别。

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

这些信息可以在 MongoDB 的官方文档中找到：[Read Concern](https://docs.mongodb.com/manual/reference/read-concern/)
以下是一个使用 Read Concern 的示例：

```javascript
db.collection.find(
   <query>,
   { readConcern: { level: "majority" } }
)
```

在这个示例中，查询操作将返回已经复制到大多数副本集成员的数据。

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

以下是一个使用 Write Concern 的示例：

```js
db.collection.insert(
   <document>,
   { writeConcern: { w: "majority", j: true, wtimeout: 1000 } }
)
```

在这个示例中，插入操作将等待大多数副本集成员确认写入操作，并且如果写入操作在 1 秒内未完成，将停止等待。

## 事务

MongoDB 的事务允许执行多个操作作为一个单一的、原子性的单位。这意味着，如果一个事务成功，则它的所有操作都会被应用，并且在任何后续的读取操作中都可以看到这些更改。如果一个事务遇到错误，则它的所有操作都不会被应用。

MongoDB 的事务提供了以下几个关键特性：

- **原子性**：事务中的所有操作要么全部成功，要么全部失败。
- **一致性**：事务确保数据库从一个一致的状态转换到另一个一致的状态。
- **隔离性**：在事务正在进行时，其操作结果对其他事务是不可见的。
- **持久性**：一旦事务被提交，其更改就是永久性的，即使发生系统故障也不会丢失。

以下是一个 MongoDB 事务的示例：

在这个示例中，插入书籍和作者的操作被包含在一个事务中，要么两个操作都成功，要么两个操作都不会被应用。

MongoDB 的事务功能在某些方面与传统的关系型数据库（如 MySQL）的事务功能相比可能存在一些限制：

1. **性能**：MongoDB 的事务可能会对性能产生影响，特别是在处理大量数据或进行复杂查询时。这是因为 MongoDB 需要在事务期间维护额外的状态信息，并在事务结束时清理这些信息。

2. **跨集群事务**：在 MongoDB 4.0 版本中，事务只支持单个副本集。直到 4.2 版本，MongoDB 才开始支持跨分片的事务，但这可能会增加事务的复杂性和开销。

3. **持久性**：在 MongoDB 中，事务的持久性取决于 Write Concern 的设置。如果 Write Concern 设置为 "majority"，那么只有当事务的更改已经复制到大多数副本集成员时，这些更改才被视为持久的。这与 MySQL 不同，MySQL 的事务一旦提交，更改就是持久的。

4. **超时限制**：MongoDB 的事务有一个默认的超时限制，如果事务在这个时间限制内没有完成，那么事务将被自动中止。这可能会影响到需要长时间运行的事务。

5. **复杂性**：MongoDB 的事务需要手动开始和结束，这可能会增加应用程序的复杂性。

## [Change Streams](https://www.mongodb.com/docs/manual/changeStreams/)

MongoDB 的 Change Streams 是一种允许应用程序访问实时数据库更改的功能。它们可以在集合、数据库或整个部署（包括分片集群）级别打开，可以订阅所有数据更改并立即对其做出反应。由于 Change Streams 使用了聚合框架，应用程序还可以过滤特定的更改或按需转换通知。

从 MongoDB 5.1 开始，Change Streams 进行了优化，提供了更高效的资源利用和某些聚合管道阶段的更快执行。

Change Streams 可用于副本集和分片集群，但需要满足以下条件：

- 存储引擎：副本集和分片集群必须使用 WiredTiger 存储引擎。Change Streams 也可以在使用了 MongoDB 的数据在静态加密特性的部署中使用。
- 副本集协议版本：副本集和分片集群必须使用副本集协议版本 1（pv1）。
- "majority" 读取关注（read concern）的启用：从 MongoDB 4.2 开始，无论是否支持 "majority" 读取关注，Change Streams 都可用。在 MongoDB 4.0 及更早版本中，只有在启用了 "majority" 读取关注（默认启用）时，Change Streams 才可用。

可以在集合、数据库或整个部署（副本集或分片集群）上打开 Change Streams，以监视所有非系统集合的更改（排除 admin、local 和 config 数据库）。

Change Streams 在性能方面需要考虑的是，如果针对数据库打开的活动 Change Streams 数量超过了连接池大小，可能会出现通知延迟。在分片集群中使用 Change Streams 时，mongos 会在每个分片上创建单独的 Change Streams，接收到 Change Streams 结果后，它会对这些结果进行排序和过滤，如果需要，还会执行 fullDocument 查找。为了获得最佳性能，应限制在 Change Streams 中使用 $lookup 查询。

生产环境 Change Streams 最佳实践：

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

- 大小写不敏感索引（Case-Insensitive Indexes）：允许你在查询时忽略字段值的大小写。

- 隐藏索引（Hidden Indexes）：不会被查询优化器用于查询计划，但仍然会接收写操作。

- 部分索引（Partial Indexes）：只包含满足过滤条件的文档，可以减少索引的大小和提高写操作的性能。

- 稀疏索引（Sparse Indexes）：只包含存在索引字段的文档，对于不存在索引字段的文档，不会在索引中创建条目。

- TTL 索引（TTL Indexes）：这种索引允许你设置文档的生存时间，MongoDB 会自动删除过期的文档。

- 唯一索引（Unique Indexes）：强制字段值的唯一性，不允许插入具有相同索引字段值的文档。

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

在 MongoDB 的分片架构中，主要有以下三种角色类型：

1. **Shard**：存储数据的节点或副本集。在分片集群中，数据被分布在多个 shard 上。

2. **Mongos**：路由进程，接收客户端的请求并将其路由到适当的 shard。客户端不直接与 shard 交互，而是通过 mongos。

3. **Config Server**：存储集群的元数据和配置信息。在生产环境中，通常使用一个副本集作为配置服务器，以提供冗余和数据一致性。

![](https://www.mongodb.com/docs/manual/images/sharded-cluster-production-architecture.bakedsvg.svg)
