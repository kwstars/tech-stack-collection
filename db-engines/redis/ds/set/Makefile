REDIS_CLI = docker exec redis redis-cli

get-set-max-intset-entries:
	@$(REDIS_CLI) CONFIG GET set-max-intset-entries

# Since Redis 7.2
# get-set-max-listpack-entries:
# 	@$(REDIS_CLI) CONFIG GET set-max-listpack-entries

# Since Redis 7.2
# get-set-max-listpack-value:
# 	@$(REDIS_CLI) CONFIG GET set-max-listpack-value

internal-encoding-intset:
	@$(REDIS_CLI) SADD $@ 1 2 3 4
	@$(REDIS_CLI) OBJECT ENCODING $@

# 转换为 hashtable 编码
test-set-due-to-max-entries:
	@$(REDIS_CLI) SADD $@ $$(seq 1 513)
	@$(REDIS_CLI) OBJECT ENCODING $@

internal-encoding-hashtable:
	@$(REDIS_CLI) SADD $@ a b c d
	@$(REDIS_CLI) OBJECT ENCODING $@

# 将 member1, member2, member3 添加到名为 myset 的集合中
sadd-key-member:
	@$(REDIS_CLI) SADD myset member1 member2 member3

# 获取名为 myset 的集合的成员数
# 返回名为 key 的集合的成员数量。如果 key 不存在，那么返回 0。
scard-key:
	@$(REDIS_CLI) SCARD myset

# 返回名为 myset 和 otherset 的集合的差集
sdiff-key:
	@$(REDIS_CLI) SDIFF myset otherset

# 返回名为 myset 和 otherset 的集合的交集
sinter-key:
	@$(REDIS_CLI) SINTER myset otherset

# 判断 member1 是否是名为 myset 的集合的成员
sismember-key-member:
	@$(REDIS_CLI) SISMEMBER myset member1

# 返回名为 myset 的集合中的所有成员
# 返回名为 key 的集合的所有成员。如果 key 不存在，那么返回一个空集合。
smembers-key:
	@$(REDIS_CLI) SMEMBERS myset

# 移除并返回名为 myset 的集合中的一个随机元素
spop-key:
	@$(REDIS_CLI) SPOP myset

# 返回名为 myset 的集合中的一个随机元素
srandmember-key:
	@$(REDIS_CLI) SRANDMEMBER myset

# 从名为 myset 的集合中移除 member1
srem-key-member:
	@$(REDIS_CLI) SREM myset member1

# 返回名为 myset 和 otherset 的集合的并集
sunion-key:
	@$(REDIS_CLI) SUNION myset otherset

# 从名为 myset 的集合中迭代元素，开始于游标 0
sscan-key:
	@$(REDIS_CLI) SSCAN myset 0
