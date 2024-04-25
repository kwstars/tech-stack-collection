## [DDL](https://dev.mysql.com/doc/refman/8.0/en/innodb-online-ddl-operations.html)

DDL，全称为数据定义语言（Data Definition Language），主要用于定义和管理 SQL 数据库中的结构和对象。DDL 包括以下几种主要的 SQL 命令：

- `CREATE`：用于创建新的数据库、表、索引等。
- `ALTER`：用于修改已存在的数据库对象，如修改表结构（例如添加或删除列，更改列的数据类型等）。
- `DROP`：用于删除数据库、表、索引等。
- `TRUNCATE`：用于删除表的所有行，但保留表结构（即列）以供后续使用。
- `RENAME`：用于重命名数据库或表。

## [DML](https://dev.mysql.com/doc/refman/8.0/en/sql-data-manipulation-statements.html)

DML，全称为数据操纵语言（Data Manipulation Language），主要用于插入、更新和删除数据库中的数据。DML 包括以下几种主要的 SQL 命令：

- `INSERT`：用于向数据库表中插入新的数据。
- `UPDATE`：用于更新数据库表中的数据。
- `DELETE`：用于从数据库表中删除数据。

## [TCL](https://dev.mysql.com/doc/refman/8.0/en/commit.html)

TCL，全称为事务控制语言（Transaction Control Language），主要用于管理对数据库事务的更改。TCL 包括以下几种主要的 SQL 命令：

- `COMMIT`：用于保存对数据库的所有更改。一旦提交了事务，就不能撤销。
- `ROLLBACK`：用于撤销未提交的更改。只有在最近的 `COMMIT` 之后进行的更改才能被撤销。
- `SAVEPOINT`：用于在事务中创建一个可以回滚到的点。如果事务中的一部分更改需要被撤销，但你不想撤销所有更改，可以使用 `SAVEPOINT`。
- `START TRANSACTION`：用于开始一个新的事务。

## [DCL](https://dev.mysql.com/doc/refman/8.0/en/account-management-statements.html)

DCL，全称为数据控制语言（Data Control Language），主要用于控制数据库系统的访问。DCL 包括以下几种主要的 SQL 命令：

- `GRANT`：用于给用户授予数据库访问的权限。
- `REVOKE`：用于撤销用户的数据库访问权限。

## [DQL](https://dev.mysql.com/doc/refman/8.0/en/select.html)

DQL，全称为数据查询语言（Data Query Language），是 SQL 语言的一部分，主要用于查询数据库中的数据。DQL 主要包括以下 SQL 命令：

- `SELECT`：用于从数据库中选择数据。这是 DQL 的核心，也是最常用的命令。`SELECT` 可以与许多子句一起使用，如 `FROM`、`WHERE`、`GROUP BY`、`HAVING`、`ORDER BY` 等，以创建复杂的查询。

![SQL Query Execution Order](https://image.linux88.com/2024/04/25/bde73a876cc2f3fa4f81749c7208a3aa.jpg)

### Filtering Data

在 SQL 中，"Filtering Data" 是指使用特定的条件来筛选出需要的数据。以下是一些常用的筛选数据的 SQL 命令：

- `WHERE`：用于过滤结果集中的数据。只有满足 `WHERE` 后面的条件的数据才会被返回。
- `LIKE`：用于在 `WHERE` 子句中搜索模式。可以与通配符一起使用，如 `%`（匹配任意数量的字符）和 `_`（匹配单个字符）。
- `IN`：允许你指定多个值，用于 `WHERE` 子句。如果列的值在 `IN` 后面的列表中，那么这个数据就会被返回。
- `AND`：用于在 `WHERE` 子句中组合多个条件。只有所有的条件都满足，数据才会被返回。
- `OR`：用于在 `WHERE` 子句中组合多个条件。只要任何一个条件满足，数据就会被返回。
- `IS NULL`：用于在 `WHERE` 子句中查找空（NULL）值。如果列的值是 NULL，那么这个数据就会被返回。
- `IS NOT NULL`：用于在 `WHERE` 子句中查找非空（NOT NULL）值。如果列的值不是 NULL，那么这个数据就会被返回。
- `BETWEEN`：用于在 `WHERE` 子句中选择介于两个值之间的范围的数据。如果列的值在 `BETWEEN` 后面的两个值之间，那么这个数据就会被返回。

这些命令可以单独使用，也可以组合使用，以创建复杂的筛选条件。

### [Aggregate Functions](https://dev.mysql.com/doc/refman/8.0/en/aggregate-functions.html)

在 SQL 中，聚合函数（Aggregate Function）是用于对一组值进行计算，并返回单个值的函数。以下是一些常用的聚合函数：

- `GROUP BY`：用于将结果集按照一个或多个列进行分组。
- `HAVING`：用于过滤 `GROUP BY` 后的结果集。
- `ORDER BY`：用于对结果集进行排序。
- `COUNT()`：返回特定列的行数。
- `MIN()`：返回特定列的最小值。
- `SUM()`：返回特定列的总和。
- `AVG()`：返回特定列的平均值。
- `MAX()`：返回特定列的最大值。

### Combining Data

在 SQL 中，"Combining Data" 通常指的是使用 `JOIN` 操作来组合两个或多个表的数据。以下是一些常用的 `JOIN` 类型：

- `INNER JOIN`：返回两个表中都有匹配的行。如果在一个表中存在某行，但在另一个表中没有匹配的行，则不会返回该行。

- `LEFT JOIN`（或 `LEFT OUTER JOIN`）：返回左表中的所有行，即使在右表中没有匹配的行。如果在右表中没有匹配的行，则结果是 NULL。

- `RIGHT JOIN`（或 `RIGHT OUTER JOIN`）：返回右表中的所有行，即使在左表中没有匹配的行。如果在左表中没有匹配的行，则结果是 NULL。

- `FULL JOIN`（或 `FULL OUTER JOIN`）：返回左表和右表中的所有行。如果在一个表中存在某行，但在另一个表中没有匹配的行，则结果是 NULL。

![SQL Joins Explained with Query](https://image.linux88.com/2024/04/25/796f4d3c5e6bd610fac2ae3cb3b6267a.jpg)
