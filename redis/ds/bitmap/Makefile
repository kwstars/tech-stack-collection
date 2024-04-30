REDIS_CLI = docker exec redis redis-cli

# 在 'mybitmap' 的 Bitmaps 中，将 offset 7 的位设置为 1
setbit:
	$(REDIS_CLI) SETBIT mybitmap 7 1

# 获取 'mybitmap' 的 Bitmaps 中，offset 7 的位
getbit:
	$(REDIS_CLI) GETBIT mybitmap 7

# 统计 'mybitmap' 的 Bitmaps 中，值为 1 的位的数量
bitcount:
	$(REDIS_CLI) BITCOUNT mybitmap

# 在 key1 的第 6 位和第 7 位设置位为 1，然后在 key2 的第 7 位设置位为 1，接着执行一个 AND 位操作，
# 将 key1 和 key2 的结果存储在 destkey 中，最后统计 destkey 中值为 1 的位的数量。
bitop:
	$(REDIS_CLI) SETBIT key1 6 1
	$(REDIS_CLI) SETBIT key1 7 1
	$(REDIS_CLI) SETBIT key2 7 1
	$(REDIS_CLI) BITOP AND destkey key1 key2
	$(REDIS_CLI) BITCOUNT destkey

# 在 'mybitmap' 的 Bitmaps 中，查找第一个值为 1 的位的位置
bitpos:
	$(REDIS_CLI) BITPOS mybitmap 1
