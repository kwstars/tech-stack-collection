REDIS_CLI = docker exec redis redis-cli

get-zset-max-listpack-entries:
	@$(REDIS_CLI) CONFIG GET zset-max-listpack-entries

get-zset-max-listpack-value:
	@$(REDIS_CLI) CONFIG GET zset-max-listpack-value

internal-encoding-listpack:
	@$(REDIS_CLI) ZADD $@ 1 one 2 two 3 three
	@$(REDIS_CLI) OBJECT ENCODING $@

# 当一个有序集合的成员数量大于 128 时，ZSet 数据类型会使用 skiplist 编码
test-zset-due-to-max-entries:
	@$(REDIS_CLI) ZADD $@ $$(seq 1 258)
	@$(REDIS_CLI) OBJECT ENCODING $@

# 当一个有序集合的所有成员的值都大于 64 字节时，ZSet 数据类型会使用 skiplist 编码
test-zset-due-to-max-value:
	@$(REDIS_CLI) ZADD $@ 1 $$(for i in $$(seq 1 65); do printf 'x'; done)
	@$(REDIS_CLI) OBJECT ENCODING $@

# 向有序集合 myzset 添加或更新成员，分数为 1 和 2
zadd-key-score-member:
	@$(REDIS_CLI) ZADD myzset 1 "one" 2 "two"

# 获取有序集合 myzset 的成员数
zcard-key:
	@$(REDIS_CLI) ZCARD myzset

# 计算在有序集合 myzset 中分数在 1 和 2 之间的成员数
zcount-key-min-max:
	@$(REDIS_CLI) ZCOUNT myzset 1 2

# 将有序集合 myzset 中成员 "one" 的分数增加 1
zincrby-key-increment-member:
	@$(REDIS_CLI) ZINCRBY myzset 1 "one"

# 返回有序集合 myzset 中分数在 1 和 2 之间的成员
zrangebyscore-key-min-max:
	@$(REDIS_CLI) ZRANGEBYSCORE myzset 1 2

# 返回有序集合 myzset 中成员 "one" 的索引
zrank-key-member:
	@$(REDIS_CLI) ZRANK myzset "one"

# 从有序集合 myzset 中移除成员 "one"
zrem-key-member:
	@$(REDIS_CLI) ZREM myzset "one"

# 从有序集合 myzset 中移除索引在 0 和 1 之间的所有成员
zremrangebyrank-key-start-stop:
	@$(REDIS_CLI) ZREMRANGEBYRANK myzset 0 1

# 从有序集合 myzset 中移除分数在 1 和 2 之间的所有成员
zremrangebyscore-key-min-max:
	@$(REDIS_CLI) ZREMRANGEBYSCORE myzset 1 2

# 返回有序集合 myzset 中索引在 0 和 1 之间的成员, 分数从低到高
zrange-key-start-stop:
	@$(REDIS_CLI) ZRANGE myzset 0 1

# 返回有序集合 myzset 中索引在 0 和 1 之间的成员，分数从高到低
zrevrange-key-start-stop:
	@$(REDIS_CLI) ZREVRANGE myzset 0 1

# 返回有序集合 myzset 中成员 "one" 的分数
zscore-key-member:
	@$(REDIS_CLI) ZSCORE myzset "one"
