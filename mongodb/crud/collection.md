```js
// 创建集合
db.createCollection("myCollection");

// 重命名集合
db.myCollection.renameCollection("newCollectionName");

// 删除集合，索引也会被删除
db.myCollection.drop();
```
