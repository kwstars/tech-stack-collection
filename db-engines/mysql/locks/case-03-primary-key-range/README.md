## 主键索引范围锁

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

### 示例说明

|     | Session A                                                       | Session B                                                                    | Session C                           |
| --- | --------------------------------------------------------------- | ---------------------------------------------------------------------------- | ----------------------------------- |
| T1  | begin;<br />select \* from t where id>=10 and id<11 for update; |                                                                              |                                     |
| T2  |                                                                 | insert into t values(8,8,8);(ok)<br />insert into values(13,13,13);(blocked) |                                     |
| T3  |                                                                 |                                                                              | update t set d=d+1 where id=15;(ok) |

1. 在执行查询时，虽然原本应该对区间 (5,10] 加 next-key lock，但由于主键 id 的等值条件，根据优化 1 只对 id=10 这一行加行锁。
2. 在范围查找过程中，系统会继续查找直到 id=15，然后对区间 (10,15] 加上 next-key lock。
3. 测试结果范围是 (5, 15)

> [!warn] 为什么这里的 15 可以更新
>
> SELECT VERSION(); 8.0.36
