## [Replication Methods](https://www.mongodb.com/docs/manual/reference/method/js-replication/)

- `rs.add()`：向副本集添加一个成员。
- `rs.addArb()`：向副本集添加一个仲裁者。
- `rs.conf()`：返回副本集的配置文档。
- `rs.freeze()`：阻止当前成员在一段时间内寻求作为主节点的选举。
- `rs.initiate()`：初始化一个新的副本集。
- `rs.printReplicationInfo()`：从主节点的角度打印副本集状态的格式化报告。
- `rs.printSecondaryReplicationInfo()`：从次级节点的角度打印副本集状态的格式化报告。
- `rs.reconfig()`：通过应用新的副本集配置对象来重新配置副本集。
- `rs.remove()`：从副本集中移除一个成员。
- `rs.status()`：返回一个包含副本集状态信息的文档。
- `rs.stepDown()`：使当前的主节点变为次级节点，这将强制进行选举。
- `rs.syncFrom()`：设置这个副本集成员将从哪个成员同步，覆盖默认的同步目标选择逻辑。

## [`rs.status()`](https://www.mongodb.com/docs/manual/reference/command/replSetGetStatus/)

```js
{
  set: 'rs0',  // 副本集的名称
  date: ISODate('2024-04-25T05:13:51.973Z'),  // 状态报告的日期和时间
  myState: 1,  // 该成员的状态码。1 表示它是主节点
  term: Long('1'),  // 该成员在当前选举轮次中的编号
  syncSourceHost: '',  // 该成员正在从哪个主机同步数据
  syncSourceId: -1,  // 该成员正在从哪个成员ID同步数据
  heartbeatIntervalMillis: Long('2000'),  // 心跳间隔，单位为毫秒
  majorityVoteCount: 2,  // 需要进行选举的多数票数
  writeMajorityCount: 2,  // 需要确认写操作的多数票数
  votingMembersCount: 3,  // 有投票权的成员数量
  writableVotingMembersCount: 3,  // 有投票权且可写的成员数量
  optimes: {
    lastCommittedOpTime: { ts: Timestamp({ t: 1714022026, i: 1 }), t: Long('1') },  // 最后提交的操作的时间戳和选举编号
    lastCommittedWallTime: ISODate('2024-04-25T05:13:46.818Z'),  // 最后提交的操作的物理时间
    readConcernMajorityOpTime: { ts: Timestamp({ t: 1714022026, i: 1 }), t: Long('1') },  // 读取关注的多数操作的时间戳和选举编号
    appliedOpTime: { ts: Timestamp({ t: 1714022026, i: 1 }), t: Long('1') },  // 已应用的操作的时间戳和选举编号
    durableOpTime: { ts: Timestamp({ t: 1714022026, i: 1 }), t: Long('1') },  // 持久的操作的时间戳和选举编号
    lastAppliedWallTime: ISODate('2024-04-25T05:13:46.818Z'),  // 最后应用的操作的物理时间
    lastDurableWallTime: ISODate('2024-04-25T05:13:46.818Z')  // 最后持久的操作的物理时间
  },
  lastStableRecoveryTimestamp: Timestamp({ t: 1714022016, i: 1 }),  // 最后稳定恢复的时间戳
  electionCandidateMetrics: {
    lastElectionReason: 'electionTimeout',  // 最后一次选举的原因
    lastElectionDate: ISODate('2024-04-25T05:06:56.671Z'),  // 最后一次选举的日期
    electionTerm: Long('1'),  // 选举期限
    lastCommittedOpTimeAtElection: { ts: Timestamp({ t: 1714021606, i: 1 }), t: Long('-1') },  // 在选举时最后提交的操作时间
    lastSeenOpTimeAtElection: { ts: Timestamp({ t: 1714021606, i: 1 }), t: Long('-1') },  // 在选举时最后看到的操作时间
    numVotesNeeded: 2,  // 需要的投票数
    priorityAtElection: 1,  // 在选举时的优先级
    electionTimeoutMillis: Long('10000'),  // 选举超时时间（毫秒）
    numCatchUpOps: Long('0'),  // 需要追赶的操作数
    newTermStartDate: ISODate('2024-04-25T05:06:56.763Z'),  // 新任期开始日期
    wMajorityWriteAvailabilityDate: ISODate('2024-04-25T05:06:57.294Z')  // 多数写可用性日期
  },
  members: [
    {
      _id: 0,  // 成员的唯一标识符
      name: 'mongo1:27017',  // 成员的主机名和端口号
      health: 1,  // 成员的健康状态。1 表示健康，0 表示不健康
      state: 1,  // 成员的状态码。1 表示它是主节点
      stateStr: 'PRIMARY',  // 成员的状态字符串。"PRIMARY" 表示它是主节点
      uptime: 467,  // 成员的运行时间，单位为秒
      optime: { ts: Timestamp({ t: 1714022026, i: 1 }), t: Long('1') },  // 成员的操作时间
      optimeDate: ISODate('2024-04-25T05:13:46.000Z'),  // 每个成员的 oplog 中最后一个操作发生的时间（也就是成员被同步到的地方）。注意， 这是每个成员通过心跳报告上来的状态，因此这个时间可能会有几秒的偏差。
      lastAppliedWallTime: ISODate('2024-04-25T05:13:46.818Z'),  // 最后应用的操作的物理时间
      lastDurableWallTime: ISODate('2024-04-25T05:13:46.818Z'),  // 最后持久的操作的物理时间
      syncSourceHost: '',  // 该成员正在从哪个主机同步数据
      syncSourceId: -1,  // 该成员正在从哪个成员ID同步数据
      infoMessage: '',  // 有关成员状态的附加信息
      electionTime: Timestamp({ t: 1714021616, i: 1 }),  // 成员最后一次选举的时间
      electionDate: ISODate('2024-04-25T05:06:56.000Z'),  // 成员最后一次选举的日期
      configVersion: 4,  // 副本集配置的版本
      configTerm: 1,  // 副本集配置的术语
      self: true,  // 只会出现在运行 rs.status() 的成员中。
      lastHeartbeatMessage: ''  // 最后一个心跳消息
    },
    {
      _id: 1,
      name: 'mongo2:27017',
      health: 1,
      state: 2,
      stateStr: 'SECONDARY',
      uptime: 425,
      optime: { ts: Timestamp({ t: 1714022026, i: 1 }), t: Long('1') },
      optimeDurable: { ts: Timestamp({ t: 1714022026, i: 1 }), t: Long('1') },
      optimeDate: ISODate('2024-04-25T05:13:46.000Z'),
      optimeDurableDate: ISODate('2024-04-25T05:13:46.000Z'),
      lastAppliedWallTime: ISODate('2024-04-25T05:13:46.818Z'),
      lastDurableWallTime: ISODate('2024-04-25T05:13:46.818Z'),
      lastHeartbeat: ISODate('2024-04-25T05:13:50.857Z'),
      lastHeartbeatRecv: ISODate('2024-04-25T05:13:50.857Z'),
      pingMs: Long('0'),
      lastHeartbeatMessage: '',
      syncSourceHost: 'mongo1:27017',
      syncSourceId: 0,
      infoMessage: '',
      configVersion: 4,
      configTerm: 1
    },
    {
      _id: 2,
      name: 'mongo3:27017',
      health: 1,
      state: 2,
      stateStr: 'SECONDARY',
      uptime: 33,
      optime: { ts: Timestamp({ t: 1714022026, i: 1 }), t: Long('1') },
      optimeDurable: { ts: Timestamp({ t: 1714022026, i: 1 }), t: Long('1') },
      optimeDate: ISODate('2024-04-25T05:13:46.000Z'),
      optimeDurableDate: ISODate('2024-04-25T05:13:46.000Z'),
      lastAppliedWallTime: ISODate('2024-04-25T05:13:46.818Z'),
      lastDurableWallTime: ISODate('2024-04-25T05:13:46.818Z'),
      lastHeartbeat: ISODate('2024-04-25T05:13:50.857Z'),
      lastHeartbeatRecv: ISODate('2024-04-25T05:13:50.872Z'),
      pingMs: Long('0'),
      lastHeartbeatMessage: '',
      syncSourceHost: 'mongo2:27017',
      syncSourceId: 1,
      infoMessage: '',
      configVersion: 4,
      configTerm: 1
    }
  ],
  ok: 1,  // 表示操作成功
  '$clusterTime': {
    clusterTime: Timestamp({ t: 1714022026, i: 1 }),  // 集群的逻辑时间
    signature: {
      hash: Binary.createFromBase64('AAAAAAAAAAAAAAAAAAAAAAAAAAA=', 0),  // 用于验证集群时间的签名的哈希值
      keyId: Long('0')  // 用于验证集群时间的签名的密钥ID
    }
  },
  operationTime: Timestamp({ t: 1714022026, i: 1 })  // 最近的已知操作时间
}
```

## [`rs.conf()`](https://www.mongodb.com/docs/manual/reference/replica-configuration/)

```js
{
  _id: 'rs0',  // 副本集的名称
  version: 4,  // 副本集配置的版本
  term: 1,  // 副本集的选举轮次
  members: [
    {
      _id: 0,  // 成员的唯一标识符
      host: 'mongo1:27017',  // 成员的主机名和端口号
      arbiterOnly: false,  // 是否仅为仲裁者。仲裁者不存储数据，但可以参与选举
      buildIndexes: true,  // 是否为此成员构建索引
      hidden: false,  // 是否隐藏此成员。隐藏成员不会成为主节点，也不会被驱动程序或连接器看到
      priority: 1,  // 此成员的优先级。优先级决定了成员成为主节点的可能性
      tags: {},  // 用于自定义写关注模式和读偏好的标签
      secondaryDelaySecs: Long('0'),  // 从主节点复制操作的延迟，单位为秒
      votes: 1  // 此成员在选举中的投票数
    },
    {
      _id: 1,
      host: 'mongo2:27017',
      arbiterOnly: false,
      buildIndexes: true,
      hidden: false,
      priority: 1,
      tags: {},
      secondaryDelaySecs: Long('0'),
      votes: 1
    },
    {
      _id: 2,
      host: 'mongo3:27017',
      arbiterOnly: false,
      buildIndexes: true,
      hidden: false,
      priority: 1,
      tags: {},
      secondaryDelaySecs: Long('0'),
      votes: 1
    }
  ],
  protocolVersion: Long('1'),  // 副本集协议的版本
  writeConcernMajorityJournalDefault: true,  // 默认的多数写关注是否需要日志
  settings: {
    chainingAllowed: true,  // 是否允许链式复制
    heartbeatIntervalMillis: 2000,  // 心跳间隔，单位为毫秒
    heartbeatTimeoutSecs: 10,  // 心跳超时，单位为秒
    electionTimeoutMillis: 10000,  // 选举超时，单位为毫秒
    catchUpTimeoutMillis: -1,  // 追赶超时，单位为毫秒。-1 表示无限制
    catchUpTakeoverDelayMillis: 30000,  // 追赶接管延迟，单位为毫秒
    getLastErrorModes: {},  // 自定义的写关注模式
    getLastErrorDefaults: { w: 1, wtimeout: 0 },  // 默认的写关注设置
    replicaSetId: ObjectId('6629e4e654948afce8d45fa6')  // 副本集的唯一标识符
  }
}
```
