## [创建比较大的副本集](https://www.mongodb.com/docs/manual/core/replica-set-members/)

副本集最多只能有 50 个成员，其中只有 7 个成员拥有投票权，以减少网络流量和选举时间。如果要创建超过 7 个成员的副本集，额外的成员必须被赋予 0 投票权，可以通过配置指定。这样可以使这些成员无法在选举中投票。

```js
rs.add({ _id: 7, host: "server-7:27017", votes: 0 });
```

## [强制从成员为主要成员](https://www.mongodb.com/docs/manual/tutorial/force-member-to-be-primary/)

**通过设置优先级**：

```js
// 获取副本集配置
cfg = rs.conf();

// 修改成员的优先级：将你想要成为主节点的成员的 priority 设置为比其他成员更高的值
cfg.members[0].priority = 0.5;
cfg.members[1].priority = 0.5;
cfg.members[2].priority = 1;

// 重新配置副本集
rs.reconfig(cfg);
```

**通过冻结其他成员**：如果有 3 个成员 m0，m1，m2，m0 是主想让 m1 成为主。

```js
// 让 m2 在接下来的 120 秒内不能成为主节点。在冻结期间不能参与选举，也不能被选为主节点。
rs.freeze(120);

// 让 m0 立即放弃主节点地位，并在接下来的 120 秒内不能被重新选为主节点。"放弃主节点地位"意味着触发一个新的选举，让其他未被冻结的成员有机会被选为主节点。
rs.stepDown(120);
```

## [链式复制](https://www.mongodb.com/docs/manual/tutorial/manage-chained-replication/)

链式复制是允许一个副本集的从节点从另一个从节点复制数据，而不是直接从主节点复制。链式复制可以减轻主节点的负载，但也可能导致复制延迟增加，这取决于网络的拓扑结构。MongoDB 默认启用链式复制。

禁用链式复制：

```javascript
cfg = rs.config();
cfg.settings = {};
cfg.settings.chainingAllowed = false;
rs.reconfig(cfg);
```

重新启用链式复制：

```javascript
cfg = rs.config();
cfg.settings.chainingAllowed = true;
rs.reconfig(cfg);
```

## [更改 Oplog 的大小](https://www.mongodb.com/docs/manual/tutorial/change-oplog-size/)

修改 Oplog 的常见场景包括：

1. **从节点可能长时间离线**：如果你的从节点可能会离线很长时间，你可能需要增大 Oplog 的大小。这样，即使从节点离线一段时间，它也能从 Oplog 中找到所有错过的操作，而不需要进行全量数据同步。
2. **写操作非常频繁**：如果你的应用有大量的写操作，你可能需要增大 Oplog 的大小。因为每个写操作都会被写入 Oplog，如果 Oplog 太小，早期的操作可能会被新的操作覆盖，从而导致从节点无法找到所有错过的操作。
3. **磁盘空间有限**：如果你的服务器磁盘空间有限，你可能需要减小 Oplog 的大小。虽然这可能会增加数据同步的延迟，但是可以节省磁盘空间。

```js
// (可选）验证 oplog 的当前大小
use local
db.oplog.rs.stats().maxSize

// 改副本集成员的 oplog 大小
db.adminCommand({replSetResizeOplog: 1, size: Double(16000)})

// (可选）压缩 oplog.rs 以回收磁盘空间
use local
db.runCommand({ "compact" : "oplog.rs" })
```

