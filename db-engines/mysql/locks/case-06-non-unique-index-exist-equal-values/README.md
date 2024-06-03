## 非唯一索引上存在"等值"的例子

```sql
CREATE TABLE t (
  id int(11) NOT NULL，
  c int(11) DEFAULT NULL，
  d int(11) DEFAULT NULL，
  PRIMARY KEY (id)，
  KEY c (c)
) ENGINE = Innodb;

INSERT INTO t
VALUES(0， 0， 0)，
  (5， 5， 5)，
  (10， 10， 10)，
  (15， 15， 15)，
  (20， 20， 20)，
  (25， 25， 25)，
  (30， 10， 30);
```

|     | Session A                             | Session B                                  | Session C                          |
| --- | ------------------------------------- | ------------------------------------------ | ---------------------------------- |
| T1  | begin;<br />delete from t where c=10; |                                            |                                    |
| T2  |                                       | insert into t values(12, 12, 12);(blocked) |                                    |
| T3  |                                       |                                            | update t set d=d+1 where c=15;(ok) |

1. Session A 在遍历过程中，首先访问到第一个 c=10 的记录，并对区间 (c=5,id=5) 到 (c=10,id=10) 加上 next-key lock。
2. Session A 向右查找到 (c=15,id=15) 时结束，由于这是等值查询且不满足条件，所以 (c=10,id=10) 到 (c=15,id=15) 的锁退化为间隙锁。
3. 最终范围是索引 c 上的范围为 (c=5,id=5) -> (c=15,id=15)
