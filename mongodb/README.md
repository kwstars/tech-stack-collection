## 基本概念

以下是 [MongoDB vs MySQL](https://www.mongodb.com/docs/manual/reference/sql-comparison/) 的基本概念对比：

|    MongoDB     |  MySQL   |
| :------------: | :------: |
|    Database    | Database |
|   Collection   |  Table   |
|    Document    |   Row    |
|     Field      |  Column  |
|      BSON      |  Schema  |
| Query Language |   SQL    |

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

1. **[投票权（`votes` 参数）](https://www.mongodb.com/docs/manual/reference/replica-configuration/#mongodb-rsconf-rsconf.members-n-.votes)**：默认情况下，每个副本集成员都有投票权，可以参与选举。但是，你可以通过设置 `votes` 参数为 0 来使一个成员失去投票权。
2. **[优先级（`priority` 参数）](https://www.mongodb.com/docs/manual/reference/replica-configuration/#mongodb-rsconf-rsconf.members-n-.priority)**：这个参数决定了一个成员被选为主节点的优先级。数值越高，优先级越高。如果设置为 0，该成员将永远不会被选为主节点。
3. **[隐藏（`hidden` 参数）](https://www.mongodb.com/docs/manual/reference/replica-configuration/#mongodb-rsconf-rsconf.members-n-.hidden)**：复制主节点的数据，但对客户端应用程序是不可见的。优先级为0的成员，可以在副本集选举中投票和确认写关注（Write Concern）。

### [分片](https://www.mongodb.com/docs/manual/sharding/)

在 MongoDB 的分片架构中，主要有以下三种角色类型：

1. **Shard**：存储数据的节点或副本集。在分片集群中，数据被分布在多个 shard 上。

2. **Mongos**：路由进程，接收客户端的请求并将其路由到适当的 shard。客户端不直接与 shard 交互，而是通过 mongos。

3. **Config Server**：存储集群的元数据和配置信息。在生产环境中，通常使用一个副本集作为配置服务器，以提供冗余和数据一致性。

![](https://www.mongodb.com/docs/manual/images/sharded-cluster-production-architecture.bakedsvg.svg)
