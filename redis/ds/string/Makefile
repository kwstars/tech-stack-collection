REDIS_CLI = docker exec redis redis-cli

internal-encoding-int:
	@$(REDIS_CLI) SET $@ 8653
	@$(REDIS_CLI) OBJECT ENCODING $@

internal-encoding-embstr:
	@$(REDIS_CLI) SET $@ "hello"
	@$(REDIS_CLI) OBJECT ENCODING $@

# https://github.com/redis/redis/blob/f35f36a265403c07b119830aa4bb3b7d71653ec9/src/object.c#L113-L125
internal-encoding-raw:
	@$(REDIS_CLI) SET $@ $$(for i in $$(seq 1 45); do printf 'x'; done)
	@$(REDIS_CLI) OBJECT ENCODING $@

concurrency-cache-read:
	$(REDIS_CLI) SETNX $@ 1

concurrency-cache-write:
	$(REDIS_CLI) SET $@ 1 XX

# https://redis.io/docs/latest/commands/?group=string

# 设置名为 mykey 的键，值为 "Hello, Redis!"
set-key-value:
	@$(REDIS_CLI) SET mykey "Hello, Redis!"

# 如果名为 mykey 的键已存在，则设置其值为 "Hello"
set-key-already-exists:
	@$(REDIS_CLI) SET mykey "Hello" XX

# 获取名为 mykey 的键的值
get-key-value:
	@$(REDIS_CLI) GET mykey

# 删除名为 mykey 的键
del-key:
	@$(REDIS_CLI) DEL mykey

# 在名为 mykey 的键的值后追加 " How are you?"
append-key-value:
	@$(REDIS_CLI) APPEND mykey " How are you?"

# 获取名为 mykey 的键的值的长度
strlen-key:
	@$(REDIS_CLI) STRLEN mykey

# 如果名为 newkey 的键不存在，则设置其值为 "Hello, Redis!"
setnx-key-value:
	@$(REDIS_CLI) SETNX newkey "Hello, Redis!"

# 设置键的值，并将键的过期时间设为 60 秒
setex-key-value:
	@$(REDIS_CLI) SETEX tempkey 60 "This message will self-destruct in 60 seconds"

# 设置多个键值对
mset-keys-values:
	@$(REDIS_CLI) MSET key1 "Hello" key2 "Redis"

# 获取多个键的值
mget-keys:
	@$(REDIS_CLI) MGET key1 key2

# 将名为 counter 的键的值递增 1
incr-key:
	@$(REDIS_CLI) INCR counter

# 将名为 counter 的键的值递减 1
decr-key:
	@$(REDIS_CLI) DECR counter

# 将名为 counter 的键的值递增 5
incrby-key:
	@$(REDIS_CLI) INCRBY counter 5

# 将名为 counter 的键的值递减 5
decrby-key:
	@$(REDIS_CLI) DECRBY counter 5
