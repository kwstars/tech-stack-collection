REDIS_CLI = docker exec redis redis-cli

# 这个参数可以设置为 -5 到 -1 或正数。如果设置为 -5 到 -1，表示的是每个内部链表节点的最大大小（以字节为单位）
# 如果设置为正数，表示的是每个内部列表节点的最大元素数量。默认是 -2。
# https://github.com/redis/redis/blob/f95031c4733078788063de775c968b6dc85522c0/redis.conf#L1935-L1948
get-list-max-listpack-size:
	@$(REDIS_CLI) CONFIG GET list-max-listpack-size

# 决定了列表（List）的压缩深度。默认是 0，表示禁用所有列表压缩。
# https://github.com/redis/redis/blob/f95031c4733078788063de775c968b6dc85522c0/redis.conf#L1950-L1964
get-list-compress-depth:
	@$(REDIS_CLI) CONFIG GET list-compress-depth

# 将一个或多个值插入到名为 mylist 的列表头部
lpush-key-value:
	@$(REDIS_CLI) LPUSH mylist value1 value2

# 将一个或多个值插入到名为 mylist 的列表尾部
rpush-key-value:
	@$(REDIS_CLI) RPUSH mylist value1 value2

# 移除并返回名为 mylist 的列表的第一个元素
lpop-key:
	@$(REDIS_CLI) LPOP mylist

# 移除并返回名为 mylist 的列表的最后一个元素
rpop-key:
	@$(REDIS_CLI) RPOP mylist

# 返回名为 mylist 的列表中指定区间内的元素
lrange-key-start-stop:
	@$(REDIS_CLI) LRANGE mylist 0 -1

# 返回名为 mylist 的列表中指定位置的元素
lindex-key-index:
	@$(REDIS_CLI) LINDEX mylist 0

# 返回名为 mylist 的列表的长度
llen-key:
	@$(REDIS_CLI) LLEN mylist

# 在名为 mylist 的列表的元素前或者后插入元素
# BEFORE|AFTER: 是一个选项，表示新元素是插入到 pivot 元素的前面还是后面，在这里是 BEFORE。
# test: 匹配第一个 pivot 参数的元素名为 test 的元素。
linsert-key-before-after:
	@$(REDIS_CLI) LINSERT mylist BEFORE test value

# 设置名为 mylist 的列表中指定位置的元素值
lset-key-index-value:
	@$(REDIS_CLI) LSET mylist 0 value

# 移除名为 mylist 的列表中所有等于 value 的元素。
# count 参数：要移除的元素数量。当 count 为 0 时，会移除列表中所有等于 value 的元素。
lrem-key-count-value:
	@$(REDIS_CLI) LREM mylist 0 value
