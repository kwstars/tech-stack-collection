## 创建

第一次向一个数据库的集合中插入文档时，数据库将被自动创建

```js
db = db.getSiblingDB('newDB'); 
db.data.insert({x: 1}); 
```

## 查看

```js
// 切换数据库
use myDatabase;

// 显示所有数据库
show dbs;

// 查看当前数据库名称
db.getName();

// 查看当前数据库的统计信息
db.stats();

// 查看当前数据库的所有集合
db.getCollectionNames();

// 执行命令
db.runCommand({ ping: 1 });

// 获取错误信息
db.getLastError();
```

## 修改

MongoDB 不直接支持重命名数据库的操作。如果你需要更改数据库的名称，你需要创建一个新的数据库，并将旧数据库中的所有数据复制到新的数据库中，然后删除旧的数据库。

以下是一个例子，展示了如何创建一个新的数据库，并将数据从旧的数据库复制到新的数据库：

```js
db = db.getSiblingDB('oldDBName'); 
db.getCollectionNames().forEach(function(collection) { 
  db[collection].find().forEach(function(doc) { 
    db.getSiblingDB('newDBName')[collection].insert(doc); 
  }); 
}); 
db.dropDatabase(); 
```

在这个例子中，我们首先获取 `oldDBName` 数据库中的所有集合，然后对每个集合中的每个文档执行插入操作，将这些文档插入到 `newDBName` 数据库的相应集合中。然后，我们删除 `oldDBName` 数据库。

注意：这个操作可能需要一些时间，因为它需要将所有数据从旧的数据库复制到新的数据库。在数据复制完成之前，你应该避免对旧的数据库进行任何写操作，以防止数据不一致。

## 删除

```js
// 删除当前数据库
db.dropDatabase();
```

