## 非唯一索引等值锁

```sql
CREATE TABLE t (
  id int(11) NOT NULL,
  c int(11) DEFAULT NULL,
  d int(11) DEFAULT NULL,
  PRIMARY KEY (id),
  KEY c (c)
) ENGINE = Innodb;

INSERT INTO t
VALUES(0, 0, 0),
  (5, 5, 5),
  (10, 10, 10),
  (15, 15, 15),
  (20, 20, 20),
  (25, 25, 25);
```

|     | Session A                                                  | Session B                          | Session C                             |
| --- | ---------------------------------------------------------- | ---------------------------------- | ------------------------------------- |
| T1  | begin;<br />select id from t where c=5 lock in share mode; |                                    |                                       |
| T2  |                                                            | update t set d=d+1 where id=5;(ok) |                                       |
| T3  |                                                            |                                    | insert into t values(7,7,7);(blocked) |

1. 根据原则 1，会给区间 (0,5] 加上 next-key lock。
2. 在查询 c=5 时，由于 c 是普通索引，系统会继续向右遍历直到 c=10，期间访问到的区间 (5,10] 都会被加上 next-key lock。

   1. 根据优化 2,由于最后一个值不满足 c=5 的条件，所以加锁范围 (5,10) 退化为间隙锁。

3. 加锁范围是 (0, 5] 和 (5,10)

4. 根据原则 2，由于查询使用覆盖索引并未访问主键索引，所以主键索引未被锁定，因此 session B 的 update 语句可以执行完成。

**Lock in Share Mode vs For Update**：

- `lock in share mode`只锁定覆盖索引。如果使用`for update`，系统会认为接下来要更新数据，因此会在主键索引上加行锁。
- 为了确保数据不被更新，如果使用`lock in share mode`，应该避免覆盖索引优化，在查询中加入索引中不存在的字段。例如，将 Session A 的查询改为`select d from t where c=5 lock in share mode`。
