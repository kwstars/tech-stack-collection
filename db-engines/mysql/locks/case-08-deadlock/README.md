## 死锁

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
```

|     |                          Session A                          |                                       Session B                                        |
| --- | :---------------------------------------------------------: | :------------------------------------------------------------------------------------: |
| T1  | begin;<br />select id from t where c=10 lock in share mode; |                                                                                        |
| T2  |                                                             |                        update t set d=d+1 where c=10;(blocked)                         |
| T3  |                insert into t values(8,8,8);                 |                                                                                        |
| T4  |                                                             | Error 1213 (40001): Deadlock found when trying to get lock; try restarting transaction |

1. Session A 启动事务并执行查询，对索引 c 加了 next-key lock(5,10] 和间隙锁 (10,15)。
2. Session B 的 update 语句试图在索引 c 上加 next-key lock(5,10]，但由于该区间已被锁定，所以进入等待状态。
   1. next-key lock 的获取实际上是分两步进行的：首先获取间隙锁，然后获取行锁。
   2. Session B 首先成功获取了 (5,10) 的间隙锁，然后尝试获取 c=10 的行锁。但是，这个行锁已经被 Session A 持有，因此 Session B 被阻塞。
3. 然后 Session A 尝试插入 (8,8,8) 这一行，但是这个操作被 Session B 持有的 (5,10) 间隙锁阻塞。这就形成了一个死锁：Session A 和 Session B 互相等待对方释放锁。
