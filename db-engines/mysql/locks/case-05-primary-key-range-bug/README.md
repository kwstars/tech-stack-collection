## 唯一索引范围锁 bug

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

|     | Session A                                                       | Session B                           | Session C                           |
| --- | --------------------------------------------------------------- | ----------------------------------- | ----------------------------------- |
| T1  | begin;<br />select \* from t where id>10 and id<=15 for update; |                                     |                                     |
| T2  |                                                                 | update t set d=d+1 where id=20;(ok) |                                     |
| T3  |                                                                 |                                     | insert into t values(16,16,16);(ok) |

~~一个 bug：唯一索引上的范围查询会访问到不满足条件的第一个值为止。~~
