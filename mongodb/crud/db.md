```js
// 显示所有数据库
show dbs;

// 切换数据库
use myDatabase;

// 查看当前数据库名称
db.getName();

// 查看当前数据库的统计信息
db.stats();

// 查看当前数据库的所有集合
db.getCollectionNames();

// 删除当前数据库
db.dropDatabase();

// 执行命令
db.runCommand({ ping: 1 });

// 获取错误信息
db.getLastError();
```
