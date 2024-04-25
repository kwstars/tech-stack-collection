## 创建 Table

```sql
-- 创建表
CREATE TABLE tablename (
    column1 datatype,
    column2 datatype,
);
```

## 查看 Table

```sql
-- 查看当前数据库的所有表
SHOW TABLES;

-- 查看表的结构
DESCRIBE tablename;
```

## [修改 Table](https://dev.mysql.com/doc/refman/8.0/en/alter-table.html)

```sql
-- 重命名表
ALTER TABLE t1 RENAME t2;

-- 更改表的存储类型
ALTER TABLE t1 TABLESPACE ts_1 STORAGE DISK;

-- 更改列的存储类型
ALTER TABLE t3 MODIFY c2 INT STORAGE MEMORY;
```

### 表结构（Column）

```sql
-- 修改列 a 的数据类型为 TINYINT NOT NULL，并将列 b 的数据类型修改为 CHAR(20)，同时将列名 b 改为 c：
ALTER TABLE t2 MODIFY a TINYINT NOT NULL, CHANGE b c CHAR(20);

-- 添加列
ALTER TABLE t2 ADD d TIMESTAMP;

-- 添加索引
ALTER TABLE t2 ADD INDEX (d), ADD UNIQUE (a);

-- 添加一个新的 AUTO_INCREMENT 类型的整数列 c，并将其设置为主键
ALTER TABLE t2 ADD c INT UNSIGNED NOT NULL AUTO_INCREMENT, ADD PRIMARY KEY (c);
```

## 删除 Table

```sql
-- 删除表
DROP TABLE tablename;
```
