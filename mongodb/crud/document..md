## 创建

```js
db.fruit.insertOne({ name: "apple" });

db.fruit.insertMany([{ name: "apple" }, { name: "pear" }, { name: "orange" }]);
```

## 查询

### 基本查询

```js
db.movies.find({ year: 1975 }); //单条件查询
db.movies.find({ year: 1989, title: "Batman" }); //多条件and查询
db.movies.find({ $and: [{ title: "Batman" }, { category: "action" }] }); // and的另一种形式
db.movies.find({ $or: [{ year: 1989 }, { title: "Batman" }] }); //多条件or查询
db.movies.find({ title: /^B/ }); //按正则表达式查找
```

### 搜索子文档

```js
// 插入一个新的文档到 "fruit" 集合中
// 文档包含 "name" 和 "from" 字段，其中 "from" 是一个嵌套的文档，包含 "country" 和 "province" 字段
db.fruit.insertOne({
  name: "apple",
  from: {
    country: "China",
    province: "Guangdon",
  },
});

// 在 "fruit" 集合中查找 "from.country" 字段值为 "China" 的所有文档
db.fruit.find({ "from.country": "China" });
```

### 搜索数组

```js
// 插入两个新的文档到 "fruit" 集合中
// 每个文档都包含 "name" 和 "color" 字段，其中 "color" 是一个数组
db.fruit.insert([
  { name: "Apple", color: ["red", "green"] },
  { name: "Mango", color: ["yellow", "green"] },
]);

// 在 "fruit" 集合中查找 "color" 字段包含 "red" 的所有文档
db.fruit.find({ color: "red" });

// 在 "fruit" 集合中查找 "color" 字段包含 "red" 或 "yellow" 的所有文档
db.fruit.find({ $or: [{ color: "red" }, { color: "yellow" }] });
```

### 搜索数组中的对象

```js
db.movies.insertOne({
  title: "Raiders of the Lost Ark",
  filming_locations: [
    { city: "Los Angeles", state: "CA", country: "USA" },
    { city: "Rome", state: "Lazio", country: "Italy" },
    { city: "Florence", state: "SC", country: "USA" },
  ],
});

// 在 "movies" 集合中查找 "filming_locations.city" 字段值为 "Rome" 的所有文档
db.movies.find({ "filming_locations.city": "Rome" });

// 会得到所有包含 "city" 为 "Rome" 的文档，不管 "country" 是什么
db.getCollection("movies").find({
  "filming_locations.city": "Rome",
  "filming_locations.country": "USA",
});

// 保证数组中的对象的 city 和 country 都匹配
db.getCollection("movies").find({
  filming_locations: {
    $elemMatch: { city: "Rome", country: "USA" },
  },
});
```

### 返回特定的字段

```js
db.inventory.insertMany([
  { item: "journal", status: "A", size: { h: 14, w: 21, uom: "cm" }, instock: [{ warehouse: "A", qty: 5 }] },
  { item: "notebook", status: "A", size: { h: 8.5, w: 11, uom: "in" }, instock: [{ warehouse: "C", qty: 5 }] },
  { item: "paper", status: "D", size: { h: 8.5, w: 11, uom: "in" }, instock: [{ warehouse: "A", qty: 60 }] },
  { item: "planner", status: "D", size: { h: 22.85, w: 30, uom: "cm" }, instock: [{ warehouse: "A", qty: 40 }] },
  {
    item: "postcard",
    status: "A",
    size: { h: 10, w: 15.25, uom: "cm" },
    instock: [
      { warehouse: "B", qty: 15 },
      { warehouse: "C", qty: 35 },
    ],
  },
]);

// 类似 SELECT _id, item, status from inventory WHERE status = "A"
db.inventory.find({ status: "A" }, { item: 1, status: 1 });
```

### [查询条件（Query Selectors）](https://www.mongodb.com/docs/manual/reference/operator/query/)

在 MongoDB 中，查询选择器用于选择满足特定条件的文档。以下是一些常用的查询选择器：

**比较操作符**

- `$eq`：匹配等于指定值的值。
- `$gt`：匹配大于指定值的值。
- `$gte`：匹配大于或等于指定值的值。
- `$in`：匹配数组中指定的任何值。
- `$lt`：匹配小于指定值的值。
- `$lte`：匹配小于或等于指定值的值。
- `$ne`：匹配所有不等于指定值的值。
- `$nin`：匹配数组中未指定的所有值。

**逻辑操作符**

- `$and`：使用逻辑 AND 连接查询子句，返回匹配两个子句条件的所有文档。
- `$not`：反转查询表达式的效果，返回不匹配查询表达式的文档。
- `$nor`：使用逻辑 NOR 连接查询子句，返回未匹配两个子句的所有文档。
- `$or`：使用逻辑 OR 连接查询子句，返回匹配任一子句条件的所有文档。

**元素操作符**

- `$exists`：匹配具有指定字段的文档。
- `$type`：如果字段是指定类型，则选择文档。

在 MongoDB 中，查询选择器还包括以下几种类型：

**评估操作符**

- `$expr`：允许在查询语言中使用聚合表达式。
- `$jsonSchema`：根据给定的 JSON Schema 验证文档。
- `$mod`：对字段值执行模运算，并选择具有指定结果的文档。
- `$regex`：选择值匹配指定正则表达式的文档。
- `$text`：执行文本搜索。
- `$where`：匹配满足 JavaScript 表达式的文档。

**地理空间操作符**

- `$geoIntersects`：选择与 GeoJSON 几何图形相交的几何图形。2dsphere 索引支持 `$geoIntersects`。
- `$geoWithin`：选择在边界 GeoJSON 几何图形内的几何图形。2dsphere 和 2d 索引支持 `$geoWithin`。
- `$near`：返回接近点的地理空间对象。需要地理空间索引。2dsphere 和 2d 索引支持 `$near`。
- `$nearSphere`：返回在球体上接近点的地理空间对象。需要地理空间索引。2dsphere 和 2d 索引支持 `$nearSphere`。

**数组操作符**

- `$all`：匹配包含查询中指定的所有元素的数组。
- `$elemMatch`：如果数组字段中的元素匹配所有指定的 `$elemMatch` 条件，则选择文档。
- `$size`：如果数组字段是指定的大小，则选择文档。

**位操作符**

- `$bitsAllClear`：匹配一组位位置都为 0 的数值或二进制值。
- `$bitsAllSet`：匹配一组位位置都为 1 的数值或二进制值。
- `$bitsAnyClear`：匹配任何一位在一组位位置中值为 0 的数值或二进制值。
- `$bitsAnySet`：匹配任何一位在一组位位置中值为 1 的数值或二进制值。

**投影操作符**

- `$`：投影匹配查询条件的数组中的第一个元素。
- `$elemMatch`：投影匹配指定 `$elemMatch` 条件的数组中的第一个元素。
- `$meta`：投影在 `$text` 操作期间分配给文档的分数。
- `$slice`：限制从数组中投影的元素数量。支持跳过和限制切片。

**杂项操作符**

- `$comment`：向查询谓词添加注释。
- `$rand`：生成 0 到 1 之间的随机浮点数。

## 更新

```js
db.inventory.insertMany([
  { item: "canvas", qty: 100, size: { h: 28, w: 35.5, uom: "cm" }, status: "A" },
  { item: "journal", qty: 25, size: { h: 14, w: 21, uom: "cm" }, status: "A" },
  { item: "mat", qty: 85, size: { h: 27.9, w: 35.5, uom: "cm" }, status: "A" },
  { item: "mousepad", qty: 25, size: { h: 19, w: 22.85, uom: "cm" }, status: "P" },
  { item: "notebook", qty: 50, size: { h: 8.5, w: 11, uom: "in" }, status: "P" },
  { item: "paper", qty: 100, size: { h: 8.5, w: 11, uom: "in" }, status: "D" },
  { item: "planner", qty: 75, size: { h: 22.85, w: 30, uom: "cm" }, status: "D" },
  { item: "postcard", qty: 45, size: { h: 10, w: 15.25, uom: "cm" }, status: "A" },
  { item: "sketchbook", qty: 80, size: { h: 14, w: 21, uom: "cm" }, status: "A" },
  { item: "sketch pad", qty: 95, size: { h: 22.85, w: 30.5, uom: "cm" }, status: "A" },
]);

// 更新一个文档
db.inventory.updateOne(
  { item: "paper" },
  {
    $set: { "size.uom": "cm", status: "P" },
    $currentDate: { lastModified: true },
  }
);

// 更新多个文档
db.inventory.updateMany(
  { qty: { $lt: 50 } },
  {
    $set: { "size.uom": "in", status: "P" },
    $currentDate: { lastModified: true },
  }
);

// 替换一个文档
db.inventory.replaceOne(
  { item: "paper" },
  {
    item: "paper",
    instock: [
      { warehouse: "A", qty: 60 },
      { warehouse: "B", qty: 40 },
    ],
  }
);
```

### [更新操作符](https://www.mongodb.com/docs/manual/reference/operator/update/)

在 MongoDB 中，更新操作符用于修改文档的字段。以下是一些常用的更新操作符：

**字段操作符**

- `$currentDate`：将字段的值设置为当前日期，可以是 Date 或 Timestamp。
- `$inc`：将字段的值增加指定的数量。
- `$min`：只有当指定的值小于现有字段值时，才更新字段。
- `$max`：只有当指定的值大于现有字段值时，才更新字段。
- `$mul`：将字段的值乘以指定的数量。
- `$rename`：重命名字段。
- `$set`：设置文档中字段的值。
- `$setOnInsert`：如果更新导致文档插入，则设置字段的值。对修改现有文档的更新操作无效。
- `$unset`：从文档中删除指定的字段。

**数组操作符**

- `$`：作为占位符，更新匹配查询条件的第一个元素。
- `$[]`：作为占位符，更新匹配查询条件的文档中数组的所有元素。
- `$[<identifier>]`：作为占位符，更新匹配查询条件的文档中，所有匹配 `arrayFilters` 条件的元素。
- `$addToSet`：只有当它们在集合中不存在时，才将元素添加到数组中。
- `$pop`：删除数组的第一个或最后一个项目。
- `$pull`：删除匹配指定查询的所有数组元素。
- `$push`：向数组添加一个项目。
- `$pullAll`：从数组中删除所有匹配的值。

**修饰符**

- `$each`：修改 `$push` 和 `$addToSet` 操作符，以便为数组更新追加多个项目。
- `$position`：修改 `$push` 操作符，以指定在数组中添加元素的位置。
- `$slice`：修改 `$push` 操作符，以限制更新数组的大小。
- `$sort`：修改 `$push` 操作符，以重新排序存储在数组中的文档。

**位操作符**

- `$bit`：对整数值进行位与、位或和位异或更新。

## 删除

```js
db.inventory.insertMany( [
   { item: "journal", qty: 25, size: { h: 14, w: 21, uom: "cm" }, status: "A" },
   { item: "notebook", qty: 50, size: { h: 8.5, w: 11, uom: "in" }, status: "P" },
   { item: "paper", qty: 100, size: { h: 8.5, w: 11, uom: "in" }, status: "D" },
   { item: "planner", qty: 75, size: { h: 22.85, w: 30, uom: "cm" }, status: "D" },
   { item: "postcard", qty: 45, size: { h: 10, w: 15.25, uom: "cm" }, status: "A" },
] );


// 删除所有文档
db.inventory.deleteMany({})

// 删除所有状态为 "A" 的文档
db.inventory.deleteMany({ status : "A" })

// 删除一个状态为 "D" 的文档
db.inventory.deleteOne( { status: "D" } )
```
