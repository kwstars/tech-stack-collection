## 架构

### 逻辑视图

![A logical view of the MySQL server architecture](https://image.linux88.com/2024/04/28/155eb24f669066e09b152f2dae558aba.svg)

MySQL 的服务器架构可以逻辑上分为以下几个主要组成部分：

1. **连接处理和线程处理（Connect/thread handling）**：负责管理客户端到 MySQL 服务器的连接。当一个连接被建立时，MySQL 会为其分配一个线程。这个线程在连接的生命周期内负责执行所有的查询和命令。此外，这一层也负责认证和权限检查，确保用户有权执行请求的操作。

2. **解析器（Parser）**：解析器的任务是解析 SQL 查询，将其转换为一个内部格式，这个格式可以被优化器和存储引擎理解。解析器还会进行一些错误检查，确保查询语法正确，所引用的表和列都存在。

3. **优化器（Optimizer）**：优化器的任务是决定查询的执行计划。它会考虑多种可能的执行策略，比如使用哪个索引，以什么顺序连接表，如何进行排序等，并选择其中最有效的一种。优化器的目标是最小化查询的总成本，这通常意味着尽可能减少磁盘 I/O。

4. **存储引擎（Storage engines）**：存储引擎负责数据的存储和检索。MySQL 是一个插件式的系统，支持多种存储引擎。每种存储引擎都有其特定的特性和用途。例如，InnoDB 引擎提供了事务安全的数据存储，支持外键并有提交、回滚和崩溃恢复能力。MyISAM 引擎提供了高速存储和检索，以及全文搜索能力。Memory 引擎提供了快速的内存存储。

## [数据类型](https://dev.mysql.com/doc/refman/8.0/en/data-types.html)

MySQL 支持多种数据类型，以下是 MySQL 中的一些主要数据类型：

1. **Numeric Data Types**：包括整数类型（如 INT, SMALLINT, TINYINT, MEDIUMINT, BIGINT）、定点数类型（如 DECIMAL, NUMERIC）、浮点数类型（如 FLOAT, DOUBLE）以及位值类型（BIT）。

2. **Date and Time Data Types**：包括 DATE, TIME, DATETIME, TIMESTAMP, YEAR 等类型。

3. **String Data Types**：包括 CHAR, VARCHAR, BINARY, VARBINARY, BLOB, TEXT, ENUM, SET 等类型。

4. **Spatial Data Types**：用于地理空间数据，包括 GEOMETRY, POINT, LINESTRING, POLYGON, MULTIPOINT, MULTILINESTRING, MULTIPOLYGON, GEOMETRYCOLLECTION 等类型。

5. **JSON Data Type**：用于存储 JSON 格式的数据。

## 索引



## 复制

