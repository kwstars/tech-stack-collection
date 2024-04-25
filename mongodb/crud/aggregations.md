```js
// SELECT first_name AS '名',
//        last_name  AS '姓'
// FROM   users
// WHERE  gender = '男'
// LIMIT  20 offset 100;
db.users.aggregate([{ $match: { gender: "男" } }, { $skip: 100 }, { $limit: 20 }, { $project: { 名: "$first_name", 姓: "$last_name" } }]);

// SELECT department,
//        Count(*) AS EMP_QTY
// FROM   users
// WHERE  gender = '女'
// GROUP  BY department
// HAVING Count(*) < 10;
db.users.aggregate([{ $match: { gender: "女" } }, { $group: { _id: "$DEPARTMENT", emp_qty: { $sum: 1 } } }, { $match: { emp_qty: { $lt: 10 } } }]);
```
