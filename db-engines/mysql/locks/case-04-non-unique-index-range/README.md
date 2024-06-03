## 非唯一索引范围锁

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

|     | Session A                                                     | Session B                             | Session C                               |
| --- | ------------------------------------------------------------- | ------------------------------------- | --------------------------------------- |
| T1  | begin;<br />select \* from t where c>=10 and c<11 for update; |                                       |                                         |
| T2  |                                                               | insert into t values(8,8,8);(blocked) |                                         |
| T3  |                                                               |                                       | update t set d=d+1 where c=15;(blocked) |

1. 在执行查询时，虽然原本应该对区间 (5,10] 加 next-key lock，由于索引 c 是非唯一索引，没有优化规则，也就是说不会蜕变为行锁。
2. 在范围查找过程中，系统会继续查找直到 id=15，然后对区间 (10,15] 加上 next-key lock。
3. 最终范围是 （5, 15]
