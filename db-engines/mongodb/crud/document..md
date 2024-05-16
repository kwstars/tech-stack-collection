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

// 查找 "color" 字段包含 "red" 的所有文档
db.fruit.find({ color: "red" });

// 查找 "color" 字段包含 "red" 或 "yellow" 的所有文档
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

```js
// 假设我们有以下 `students` 集合：
db.students.insertMany([
  { name: "Alice", age: 20 },
  { name: "Bob", age: 21 },
  { name: "Charlie", age: 23 },
  { name: "David", age: 20 },
  { name: "Edward", age: 22 },
]);

// 使用 $eq 运算符查询 "age" 等于 20 的文档
db.students.find({ age: { $eq: 20 } }).pretty();
db.students.find({ age: 30 }); // 隐式等价于 `eq`

// 使用 $gt 运算符查询 "age" 大于 20 的文档
db.students.find({ age: { $gt: 20 } }).pretty();

// 使用 $gte 运算符查询 "age" 大于等于 21 的文档
db.students.find({ age: { $gte: 21 } }).pretty();

// 使用 $lt 运算符查询 "age" 小于 22 的文档
db.students.find({ age: { $lt: 22 } }).pretty();

// 使用 $lte 运算符查询 "age" 小于等于 21 的文档
db.students.find({ age: { $lte: 21 } }).pretty();

// 使用 $ne 运算符查询 "age" 不等于 20 的文档
db.students.find({ age: { $ne: 20 } }).pretty();

// 使用 $in 运算符查询 "age" 在指定的数组中的文档
db.students.find({ age: { $in: [20, 22] } }).pretty();

// 使用 $nin 运算符查询 "age" 不在指定的数组中的文档
db.students.find({ age: { $nin: [20, 22] } }).pretty();
```

**逻辑操作符**

- `$and`：使用逻辑 AND 连接查询子句，返回匹配两个子句条件的所有文档。
- `$not`：反转查询表达式的效果，返回不匹配查询表达式的文档。
- `$nor`：使用逻辑 NOR 连接查询子句，返回未匹配两个子句的所有文档。
- `$or`：使用逻辑 OR 连接查询子句，返回匹配任一子句条件的所有文档。

```js
// 插入一些文档到 `students` 集合
db.students.insertMany([
  { name: "Alice", age: 20, enrolled: true },
  { name: "Bob", age: 21, enrolled: false },
  { name: "Charlie", age: 22, enrolled: true },
  { name: "David", age: 23, enrolled: true },
  { name: "Eve", age: 20, enrolled: false },
]);

// $and 运算符: 匹配所有条件都为真的文档
db.students.find({ $and: [{ age: { $gt: 20 } }, { enrolled: true }] }).pretty();
db.students.find({ age: { $gt: 20 }, enrolled: true }).pretty(); // 隐式等价的 $and

// $or 运算符: 匹配至少一个条件为真的文档
db.students.find({ $or: [{ age: { $lt: 21 } }, { enrolled: false }] }).pretty();

// $not 运算符: 匹配条件不为真的文档
db.students.find({ age: { $not: { $gt: 21 } } }).pretty();

// $nor 运算符: 在 students 集合中查找所有既不满足 age 大于 21 的条件，也不满足 enrolled 为 true 的条件的文档，并以易读的格式输出结果。
db.students.find({ $nor: [{ age: { $gt: 21 } }, { enrolled: true }] }).pretty();
```

> [!warning]- `$and`的坑
>
> 在 MongoDB 中，如果在查询对象中多次使用同一字段名，它将只采用最后一个。
>
> 例如，在这个查询中：
>
> ```javascript
> db.students.find({ name: "Alice", name: "Bob" }).pretty();
> ```
>
> 实际上，这个查询将只会寻找名字为 "Bob" 的学生，因为 "Bob" 会覆盖先前的 "Alice" 条件。
>
> 另外，在这个查询中：
>
> ```javascript
> db.students.find({ $and: [{ name: "Alice" }, { name: "Bob" }] }).pretty();
> ```
>
> 由于使用了 `$and` 操作符，该查询尝试寻找同时满足 `name` 为 "Alice" 和 "Bob" 的学生，这在实际情况中几乎不可能，因为一个学生不可能同时有两个不同的 `name`。

> [!note]- 单个字段的多个值，那么应该尽可能使用 `$in` 而不是 `or`
>
> `$in` 和 `$or` 在某些情况下可以达到相同的效果，但是它们在 MongoDB 的查询优化器中的处理方式是不同的。
>
> 当使用 `$in` 运算符时，MongoDB 可以更有效地使用索引来优化查询。这是因为 `$in` 运算符在查询单个字段的多个值时可以直接查找索引，而无需检查每个可能的匹配项。
>
> 相比之下，`$or` 运算符需要对每个条件分别进行评估，这可能会导致更多的 CPU 使用和更慢的查询速度，特别是在处理大量数据时。
>
> 因此，虽然 `$or` 在功能上更强大（因为它可以处理多个不同的字段），但如果你只是在查询单个字段的多个值，那么应该尽可能使用 `$in`，因为它可以提供更好的性能。

**元素操作符**

- `$exists`：匹配具有指定字段的文档。
- `$type`：如果字段是指定类型，则选择文档。

```js
// 假设我们有以下 `products` 集合：
db.products.insertMany([{ _id: 1, item: null }, { _id: 2 }]);

// 使用 $exists 运算符查询字段存在的文档
db.products.find({ item: { $exists: true } });
// [ { "_id": 1, "item": null } ]

// 使用 $exists 运算符查询字段不存在的文档
db.products.find({ item: { $exists: false } });
// [ { "_id": 2 } ]

// 使用 $type 运算符查询字段类型为 string 的文档
db.products.find({ item: { $type: "string" } });
// []

// 增加一个字段类型为 string 的文档
db.products.insertOne({ _id: 3, item: "apple" });

// 再次使用 $type 运算符查询字段类型为 string 的文档
db.products.find({ item: { $type: "string" } });
// [ { "_id": 3, "item": "apple" } ]
```

**评估操作符**

- `$expr`：允许在查询语言中使用聚合表达式。
- `$jsonSchema`：根据给定的 JSON Schema 验证文档。
- `$mod`：对字段值执行模运算，并选择具有指定结果的文档。
- `$regex`：选择值匹配指定正则表达式的文档。
- `$text`：执行文本搜索。
- `$where`：匹配满足 JavaScript 表达式的文档。

```js
// 插入一个文档到 "collection" 集合
db.collection.insertOne({ _id: 1, score: 70, highScore: 100, lowScore: 50, comment: "Good job!" });

// 找出 "highScore" 字段值大于 "lowScore" 字段值的所有文档。
db.collection.find({ $expr: { $gt: ["$highScore", "$lowScore"] } });

// 找出所有满足 JSON Schema（其中 "score" 字段是必需的且必须是整数类型）的文档
db.collection.find({ $jsonSchema: { required: ["score"], properties: { score: { bsonType: "int" } } } });

// 操作找出 "score" 字段值能被 5 整除的所有文档
db.collection.find({ score: { $mod: [5, 0] } });

// 找出 "comment" 字段值以 "Good" 开头的所有文档。
db.collection.find({ comment: { $regex: /^Good/ } });

// 首先为 "comment" 字段创建一个文本索引，然后执行一个文本搜索，查找包含 "job" 的所有文档。
db.collection.createIndex({ comment: "text" });
db.collection.find({ $text: { $search: "job" } });

// 找出 "highScore" 字段值大于 "lowScore" 字段值的所有文档
db.collection.find({ $where: "this.highScore > this.lowScore" });
```

**地理空间操作符**

- `$geoIntersects`：选择与 GeoJSON 几何图形相交的几何图形。2dsphere 索引支持 `$geoIntersects`。
- `$geoWithin`：选择在边界 GeoJSON 几何图形内的几何图形。2dsphere 和 2d 索引支持 `$geoWithin`。
- `$near`：返回接近点的地理空间对象。需要地理空间索引。2dsphere 和 2d 索引支持 `$near`。
- `$nearSphere`：返回在球体上接近点的地理空间对象。需要地理空间索引。2dsphere 和 2d 索引支持 `$nearSphere`。

**数组操作符**

- `$all`：匹配包含查询中指定的所有元素的数组。
- `$elemMatch`：如果数组字段中的元素匹配所有指定的 `$elemMatch` 条件，则选择文档。
- `$size`：如果数组字段是指定的大小，则选择文档。

```js
// 插入三个文档到 "food" 集合
db.food.insertOne({ _id: 1, fruit: ["apple", "banana", "peach"] });
db.food.insertOne({ _id: 2, fruit: ["apple", "kumquat", "orange"] });
db.food.insertOne({ _id: 3, fruit: ["cherry", "banana", "apple"] });
db.food.insertOne({
  _id: 4,
  fruit: [
    { name: "apple", color: "red" },
    { name: "banana", color: "yellow" },
  ],
});
db.food.insertOne({
  _id: 5,
  fruit: [
    { name: "apple", color: "green" },
    { name: "banana", color: "yellow" },
  ],
});
db.food.insertOne({
  _id: 6,
  fruit: [
    { name: "cherry", color: "red" },
    { name: "banana", color: "yellow" },
  ],
});

// 查找 fruit 字段包含 "apple" 和 "banana" 的所有文档。
db.food.find({ fruit: { $all: ["apple", "banana"] } });

// 查找 fruit 字段恰好等于数组 ["apple", "banana", "peach"] 的所有文档。
db.food.find({ fruit: ["apple", "banana", "peach"] });

// 无法匹配, 没有 ["apple", "banana"] 这个数组
db.food.find({ fruit: ["apple", "banana"] });

// 无法匹配，因为数组的顺序不正确
db.food.find({ fruit: ["banana", "apple", "peach"] });

// 查找 fruit 字段的第三个元素（索引为2）恰好为 "peach" 的所有文档。
db.food.find({ "fruit.2": "peach" });

// 使用 $elemMatch 查找 fruit 字段中 name 为 "apple" 并且 color 为 "red" 的文档
db.food.find({ fruit: { $elemMatch: { name: "apple", color: "red" } } });

// 使用 $size 查找 fruit 字段长度为 2 的所有文档
db.food.find({ fruit: { $size: 2 } });
```

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

```js
// 插入一个文档到 "collection" 集合
db.collection.insertOne({
  _id: 1,
  scores: [70, 75, 80, 85, 90],
  comments: [
    { author: "Alice", text: "Good job!" },
    { author: "Bob", text: "Well done!" },
  ],
});

// 从 "scores" 数组中找到第一个等于 80 的元素并返回。
db.collection.find({ scores: 80 }, { "scores.$": 1 });

// 从 "_id" 为 1 的文档中找到 "comments" 数组中第一个 "author" 字段值为 "Alice" 的元素。
db.collection.find({ _id: 1 }, { comments: { $elemMatch: { author: "Alice" } } });

// 从 "_id" 为 1 的文档中找到 "scores" 数组的最后三个元素。
db.collection.find({ _id: 1 }, { scores: { $slice: -3 } });
```

**杂项操作符**

- `$comment`：向查询谓词添加注释。
- `$rand`：生成 0 到 1 之间的随机浮点数。

```js
// 插入一个文档到 "collection" 集合
db.collection.insertOne({ _id: 1, score: 70, highScore: 100, lowScore: 50 });

// 使用 $comment 向查询谓词添加注释
db.collection.find({ score: 70 }).comment("This query looks for documents where score is 70");

// 使用 $rand 生成 0 到 1 之间的随机浮点数
db.collection.aggregate([{ $sample: { size: 1 } }, { $project: { random: { $rand: {} } } }]);
```

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

```js
// 插入一个文档到 "collection" 集合
db.collection.insertOne({ _id: 1, score: 70, highScore: 100, lowScore: 50 });

// 使用 $currentDate 设置当前日期
db.collection.updateOne({ _id: 1 }, { $currentDate: { lastModified: true } });

// 使用 $inc 增加指定的数量
db.collection.updateOne({ _id: 1 }, { $inc: { score: 10 } });

// 使用 $min 只有当指定的值小于现有字段值时，才更新字段
db.collection.updateOne({ _id: 1 }, { $min: { lowScore: 40 } });

// 使用 $max 只有当指定的值大于现有字段值时，才更新字段
db.collection.updateOne({ _id: 1 }, { $max: { highScore: 110 } });

// 使用 $mul 将字段的值乘以指定的数量
db.collection.updateOne({ _id: 1 }, { $mul: { score: 2 } });

// 使用 $rename 重命名字段
db.collection.updateOne({ _id: 1 }, { $rename: { score: "totalScore" } });

// 使用 $set 设置文档中字段的值
db.collection.updateOne({ _id: 1 }, { $set: { totalScore: 80 } });

// 使用 $setOnInsert 如果更新导致文档插入，则设置字段的值
db.collection.updateOne({ _id: 2 }, { $setOnInsert: { totalScore: 90 } }, { upsert: true });

// 使用 $unset 从文档中删除指定的字段
db.collection.updateOne({ _id: 1 }, { $unset: { totalScore: "" } });
```

**数组操作符**

- `$`：作为占位符，更新匹配查询条件的第一个元素。
- `$[]`：作为占位符，更新匹配查询条件的文档中数组的所有元素。
- `$[<identifier>]`：作为占位符，更新匹配查询条件的文档中，所有匹配 `arrayFilters` 条件的元素。
- `$addToSet`：只有当它们在集合中不存在时，才将元素添加到数组中。
- `$pop`：删除数组的第一个或最后一个项目。
- `$pull`：删除匹配指定查询的所有数组元素。
- `$push`：向数组添加一个项目。
- `$pullAll`：从数组中删除所有匹配的值。

```js
// 插入五个文档到 "collection" 集合
db.collection.insertOne({ _id: 1, scores: [70, 75, 89, 89, 90] });
db.collection.insertOne({ _id: 2, scores: [80, 85, 90, 95, 100] });
db.collection.insertOne({ _id: 3, scores: [60, 65, 70, 75, 80] });
db.collection.insertOne({ _id: 4, scores: [90, 95, 100, 105, 110] });
db.collection.insertOne({ _id: 5, scores: [50, 55, 60, 65, 70] });

// 将 collection 集合中 _id 为 1 且 scores 字段包含 89 的文档中的 scores 字段的第一个值为 89 的元素更新为 90。
db.collection.updateOne({ _id: 1, scores: 89 }, { $set: { "scores.$": 90 } });

// 将 collection 集合中 _id 为 1 的文档的 scores 字段中所有值大于或等于 85 的元素更新为 100。
db.collection.updateOne({ _id: 1 }, { $set: { "scores.$[elem]": 100 } }, { arrayFilters: [{ elem: { $gte: 85 } }] });

// 将值为 89、70 和 92 的元素添加到 collection 集合中 _id 为 1 的文档的 scores 字段中，如果这些元素已经存在，则不会重复添加。
db.collection.updateOne({ _id: 1 }, { $addToSet: { scores: { $each: [89, 70, 92] } } });

// 将值为 89、90 和 92 的元素添加到 collection 集合中 _id 为 1 的文档的 scores 字段的末尾。
db.collection.updateOne({ _id: 1 }, { $push: { scores: { $each: [89, 90, 92] } } });

// 从 collection 集合中 _id 为 1 的文档的 scores 字段的末尾移除一个元素。
db.collection.updateOne({ _id: 1 }, { $pop: { scores: 1 } });

// 从 collection 集合中 _id 为 1 的文档的 scores 字段中移除所有值大于或等于 80 的元素。
db.collection.updateOne({ _id: 1 }, { $pull: { scores: { $gte: 80 } } });

// 从 collection 集合中 _id 为 1 的文档的 scores 字段中移除所有值为 70、75 的元素。
db.collection.updateOne({ _id: 1 }, { $pullAll: { scores: [70, 75] } });

// 将 collection 集合中 scores 字段包含至少一个值大于或等于 90 的所有文档的 scores 字段中的所有元素都设置为 100。
db.collection.updateMany({ scores: { $gte: 90 } }, { $set: { "scores.$[]": 100 } });
```

**修饰符**

- `$each`：修改 `$push` 和 `$addToSet` 操作符，以便为数组更新追加多个项目。
- `$position`：修改 `$push` 操作符，以指定在数组中添加元素的位置。
- `$slice`：修改 `$push` 操作符，以限制更新数组的大小。
- `$sort`：修改 `$push` 操作符，以重新排序存储在数组中的文档。

```js
// 插入一个文档到 "collection" 集合
db.collection.insertOne({ _id: 1, scores: [70, 75, 80, 85, 90] });

// 使用 $each 和 $push 将多个元素添加到数组的末尾
db.collection.updateOne({ _id: 1 }, { $push: { scores: { $each: [1, 2, 3] } } });

// 使用 $each 和 $position 将多个元素添加到数组的开始
db.collection.updateOne({ _id: 1 }, { $push: { scores: { $each: [4, 5, 6], $position: 0 } } });

// 使用 $each, $slice 和 $push 将多个元素添加到数组的末尾，并限制数组的大小为 5
db.collection.updateOne({ _id: 1 }, { $push: { scores: { $each: [7, 8, 9], $slice: -5 } } });

// 使用 $each, $sort 和 $push 将多个元素添加到数组的末尾，并对数组进行排序
db.collection.updateOne({ _id: 1 }, { $push: { scores: { $each: [10, 13, 12], $sort: 1 } } });
```

**位操作符**

- `$bit`：对整数值进行位与、位或和位异或更新。

## 删除

```js
db.inventory.insertMany([
  { item: "journal", qty: 25, size: { h: 14, w: 21, uom: "cm" }, status: "A" },
  { item: "notebook", qty: 50, size: { h: 8.5, w: 11, uom: "in" }, status: "P" },
  { item: "paper", qty: 100, size: { h: 8.5, w: 11, uom: "in" }, status: "D" },
  { item: "planner", qty: 75, size: { h: 22.85, w: 30, uom: "cm" }, status: "D" },
  { item: "postcard", qty: 45, size: { h: 10, w: 15.25, uom: "cm" }, status: "A" },
]);

// 删除所有文档
db.inventory.deleteMany({});

// 删除所有状态为 "A" 的文档
db.inventory.deleteMany({ status: "A" });

// 删除一个状态为 "D" 的文档
db.inventory.deleteOne({ status: "D" });
```
