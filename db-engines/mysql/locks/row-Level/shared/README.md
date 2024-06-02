|     | Session A                                          | Session B                    | Session C                    |
| --- | -------------------------------------------------- | ---------------------------- | ---------------------------- |
| T1  | begin;<br />select \* from t where d=5 for update; |                              |                              |
| T2  |                                                    | update t set d=5 where id=0; |                              |
| T3  | select \* from t where d=5 for update;             |                              |                              |
| T4  |                                                    |                              | insert into t values(1,1,5); |
| T5  | select \* from t where d=5 for update;             |                              |                              |
| T6  | commit;                                            |                              |                              |
