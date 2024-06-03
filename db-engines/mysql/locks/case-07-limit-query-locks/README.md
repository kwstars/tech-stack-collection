## limit 语句加锁

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

|                   Session A                   |               Session B               |
| :-------------------------------------------: | :-----------------------------------: |
| begin;<br />delete from t where c=10 limit 2; |                                       |
|                                               | insert into t values(12, 12, 12);(ok) |

在 SQL 查询中使用 limit 可以有效地控制加锁范围，从而提高并发能力。同时，为了最佳实践，建议在需要删除或修改数据时尽量使用 limit，以控制影响行数和减小加锁范围。
