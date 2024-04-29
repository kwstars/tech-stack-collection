REDIS_CLI = docker exec redis redis-cli

# 当哈希表的 filed 超过这个值时，会编程 hashtable 编码
# https://github.com/redis/redis/blob/f95031c4733078788063de775c968b6dc85522c0/redis.conf#L1929-L1933
# https://github.com/redis/redis/blob/f35f36a265403c07b119830aa4bb3b7d71653ec9/src/t_hash.c#L226-L228
get-hash-max-listpack-entries:
	@$(REDIS_CLI) CONFIG GET hash-max-listpack-entries

# 当哈希表的 value 超过这个值时，会编程 hashtable 编码
# https://github.com/redis/redis/blob/f35f36a265403c07b119830aa4bb3b7d71653ec9/src/t_hash.c#L193-L199
get-hash-max-listpack-value:
	@$(REDIS_CLI) CONFIG GET hash-max-listpack-value

internal-encoding-listpack:
	@$(REDIS_CLI) HMSET $@ f1 v1 f2 v2
	@$(REDIS_CLI) OBJECT ENCODING $@

# 当一个哈希表的键值对数量大于 512 时，Hash 数据类型会使用 hashtable 编码
test-hash-due-to-max-entries:
	@$(REDIS_CLI) HSET $@ $$(for i in $$(seq 1 513); do echo field$$i value$$i; done)
	@$(REDIS_CLI) OBJECT ENCODING $@

# 当一个哈希表的所有键值对的值都大于 64 字节时，Hash 数据类型会使用 hashtable 编码
test-hash-due-to-max-value:
	@$(REDIS_CLI) HSET $@ largevalue $$(for i in $$(seq 1 65); do printf 'x'; done)
	@$(REDIS_CLI) OBJECT ENCODING $@

# 设置 myhash 的 field1 字段为 "Hello"
hset-key-field-value:
	@$(REDIS_CLI) HSET myhash field1 "Hello"

# 获取名为 myhash 的哈希表中的 field1 字段的值
hget-key-field:
	@$(REDIS_CLI) HGET myhash field1

# 删除 myhash 中的 field1 字段
hdel-key-field:
	@$(REDIS_CLI) HDEL myhash field1

# 检查名为 myhash 的哈希表中的 field1 字段是否存在
hexists-key-field:
	@$(REDIS_CLI) HEXISTS myhash field1

# 返回名为 myhash 的哈希表中的字段数量
hlen-key:
	@$(REDIS_CLI) HLEN myhash

# 返回名为 myhash 的哈希表中的所有字段名
hkeys-key:
	@$(REDIS_CLI) HKEYS myhash

# 返回名为 myhash 的哈希表中的所有字段值
hvals-key:
	@$(REDIS_CLI) HVALS myhash

# 返回名为 myhash 的哈希表中的所有字段和值
hgetall-key:
	@$(REDIS_CLI) HGETALL myhash

# 如果名为 myhash 的哈希表中的 field1 和 field2 字段已存在，则设置其值为 "Hello" 和 "Redis"
hmset-key-field-value:
	@$(REDIS_CLI) HMSET myhash field1 "Hello" field2 "Redis"

# 获取名为 myhash 的哈希表中的 field1 和 field2 字段的值
hmget-key-field:
	@$(REDIS_CLI) HMGET myhash field1 field2

# 将名为 myhash 的哈希表中的 field1 字段的值递增 5
hincrby-key-field:
	@$(REDIS_CLI) HINCRBY myhash field1 5

# 将名为 myhash 的哈希表中的 field1 字段的值递增 1.5
hincrbyfloat-key-field:
	@$(REDIS_CLI) HINCRBYFLOAT myhash field1 1.5
