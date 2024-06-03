## 等值查询间隙锁

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

|     | Session A                                  | Session B                             | Session C                           |
| --- | ------------------------------------------ | ------------------------------------- | ----------------------------------- |
| T1  | begin;<br />update t set d=d+1 where id=7; |                                       |                                     |
| T2  |                                            | insert into t values(8,8,8);(blocked) |                                     |
| T3  |                                            |                                       | update t set d=d+1 where id=10;(ok) |

---

1. 原则 1：加锁单位是 next-key 锁。next-key 锁锁定前开后闭区间。对 id=7 加锁，锁定(5,10]。
2. 优化 2：等值查询可优化。id=7 查询，id=10 不满足。next-key 锁退化为间隙锁。
3. 最终锁定区间(5,10)。
