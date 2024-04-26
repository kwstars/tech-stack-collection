## 备份和恢复

```bash
mongodump --host localhost:27017 --oplog

mongorestore --host localhost:27017 --oplogReplay
```

## 监控

## 安全

### 认证

#### [客户端认证](https://www.mongodb.com/docs/manual/core/authentication/)

1. **SCRAM Authentication**：Salted Challenge Response Authentication Mechanism (SCRAM) 是 MongoDB 的默认认证机制。
2. **x.509 Certificate Authentication**：MongoDB 支持使用 x.509 证书进行客户端认证和复制集成员以及分片集群的内部认证。x.509 证书认证需要一个安全的 TLS/SSL 连接。
3. **Kerberos Authentication**：MongoDB Enterprise 支持 Kerberos 认证。Kerberos 是一个为大型客户端/服务器系统提供认证的行业标准协议，它使用被称为票据的短期令牌进行认证。
4. **LDAP Proxy Authentication**：MongoDB Enterprise 和 MongoDB Atlas 支持通过轻量级目录访问协议（LDAP）服务进行 LDAP 代理认证。
5. **OpenID Connect Authentication**：MongoDB Enterprise 支持 OpenID Connect 认证。OpenID Connect 是建立在 OAuth2 之上的认证层。你可以使用 OpenID Connect 在你的 MongoDB 数据库和第三方身份提供商之间配置单点登录。

#### [集群成员认证](https://www.mongodb.com/docs/manual/core/security-internal-authentication/)

MongoDB 的内部/成员认证（Internal/Membership Authentication）主要用于验证复制集或分片集群的成员身份。这种认证方式有两种主要的实现方式：Keyfiles 和 x.509 证书。

1. **Keyfiles**：Keyfiles 使用 SCRAM 挑战响应认证机制，其中 keyfiles 包含成员的共享密码。Key 的长度必须在 6 到 1024 个字符之间，并且只能包含 base64 集中的字符。

2. **x.509 证书**：复制集或分片集群的成员可以使用 x.509 证书进行内部认证，而不是使用 keyfiles。MongoDB 支持使用 x.509 证书认证，用于与安全的 TLS/SSL 连接一起使用。

### [授权](https://www.mongodb.com/docs/manual/tutorial/manage-users-and-roles/)

MongoDB 的授权机制是基于角色的，它允许管理员为每个用户分配一个或多个角色，每个角色都有一组特定的权限。

在 MongoDB 中，权限是在数据库级别控制的。这意味着每个数据库都有自己的用户和权限。一个用户在一个数据库中的权限不会影响他在另一个数据库中的权限。例如，如果一个用户在`database1`上有`readWrite`权限，在`database2`上没有任何权限，那么他只能在`database1`上读取和写入数据，在`database2`上不能做任何事情。

MongoDB 提供了一系列[内置的角色](https://www.mongodb.com/docs/manual/reference/built-in-roles/)，包括：

- `read`：允许用户读取指定数据库的数据。
- `readWrite`：允许用户读取和写入指定数据库的数据。
- `dbAdmin`：允许用户在指定数据库上执行管理函数，如索引创建、删除，查看统计信息等。
- `userAdmin`：允许用户在指定数据库上创建和修改用户和角色。
- `clusterAdmin`：提供了最高的集群管理权限，包括复制和分片相关的权限。

此外，你还可以创建自定义角色，自定义角色可以有任意组合的权限。

在 MongoDB 中，用户需要通过认证才能获得其角色所赋予的权限。认证可以在 MongoDB 服务器级别进行，也可以在单个数据库级别进行。一旦用户通过了认证，MongoDB 就会根据用户的角色来控制他们的访问权限。

```js
use test

// 创建一个名为 kira 的用户，并授予了他在 test 数据库上的 readWrite 权限。这意味着 kira 用户可以在test数据库上读取和写入数据。
db.createUser(
  {
    user: "kira",
    pwd: "kiraPassword",  // 或者使用更安全的密码
    roles: [ { role: "readWrite", db: "test" } ]
  }
)

// 修改现有用户的密码
db.changeUserPassword("kira", "SOh3TbYhxuLiW8ypJPxmt1oOfL")

// 查看用户的角色
db.getUser("kira")

// 查看角色的权限
db.getRole("readWrite", { showPrivileges: true })
```

## 工具

### `mongostat`

```bash
mongostat -u root -p mongodb --authenticationDatabase admin
insert query update delete getmore command dirty used flushes vsize  res qrw arw net_in net_out conn                time
    *0    *0     *0     *0       0     2|0  0.0% 0.0%       0 2.59G 221M 0|0 0|0   164b   70.8k   18 Apr 26 08:02:30.208
```

- `insert`：每秒插入操作的数量。
- `query`：每秒查询操作的数量。
- `update`：每秒更新操作的数量。
- `delete`：每秒删除操作的数量。
- `getmore`：每秒 getmore 操作的数量。getmore 操作通常在处理游标查询时发生。
- `command`：每秒命令数，格式为：`total|read|write`。
- `dirty`：WiredTiger 存储引擎的缓冲池中脏数据的百分比。超过 20% 时阻塞请求。
- `used`：WiredTiger 存储引擎的缓冲池中当前使用的百分比。超过 95%时阻塞请求。
- `flushes`：每秒数据刷新到磁盘的次数。
- `vsize`：MongoDB 使用的虚拟内存大小。
- `res`：MongoDB 使用的物理内存大小。
- `qrw`：客户端查询队列中读和写操作的数量，格式为：`read|write`。 排队的请求。
- `arw`：活动客户端读和写操作的数量，格式为：`read|write`。
- `net_in`：每秒网络入口流量。
- `net_out`：每秒网络出口流量。
- `conn`：当前打开到数据库的连接数。
- `time`：当前时间。

### `mongotop`

```bash
mongotop -u root -p mongodb --authenticationDatabase admin
2024-04-26T08:11:45.260+0000    connected to: mongodb://localhost/

                       ns    total    read    write    2024-04-26T08:11:46Z
     admin.$cmd.aggregate      0ms     0ms      0ms
           admin.atlascli      0ms     0ms      0ms
admin.system.backup_users      0ms     0ms      0ms
       admin.system.users      0ms     0ms      0ms
     admin.system.version      0ms     0ms      0ms
          admin.temproles      0ms     0ms      0ms
          admin.tempusers      0ms     0ms      0ms
       config.collections      0ms     0ms      0ms
          config.settings      0ms     0ms      0ms
   config.system.sessions      0ms     0ms      0ms
```

- `ns`：这是命名空间，通常表示为`database.collection`。

- `total`：这是在给定的时间段内，对特定集合的所有读写操作的总时间。

- `read`：这是在给定的时间段内，对特定集合的所有读操作的总时间。

- `write`：这是在给定的时间段内，对特定集合的所有写操作的总时间。

- `2024-04-26T08:11:46Z`：这是统计信息的时间戳，表示这些统计信息是何时收集的。
