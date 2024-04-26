## 创建

```js
db.createCollection("myCollection");
```

## 查看

```js
show collections
```

## 更新

```js
// 重命名集合
db.myCollection.renameCollection("newCollectionName");
```

## 删除

```js
// 删除集合，索引也会被删除
db.myCollection.drop();
```

