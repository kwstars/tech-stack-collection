STREAM_NAME=mystream
GROUP_NAME=mygroup
CONSUMER_NAME=myconsumer
REDIS_CLI = docker exec redis redis-cli

# 用来设置一个 Stream 节点可以包含的最大条目数。当添加新的 Stream 条目时，如果一个节点的条目数超过了这个参数设置的值，
# 那么将会创建一个新的节点来存储新的条目。如果这个参数设置为 0，那么条目数的限制将被忽略。 默认 100.
get-stream-node-max-entries:
	@$(REDIS_CLI) CONFIG GET stream-node-max-entries

# 用来设置一个 Stream 节点可以包含的最大字节数。Stream 数据结构是一个基数树，每个节点可以包含多个条目。
# 当添加新的 Stream 条目时，如果一个节点的大小超过了这个参数设置的值，那么将会创建一个新的节点来存储新的条目。
# 如果这个参数设置为 0，那么字节大小的限制将被忽略。默认 4096。
get-stream-node-max-bytes:
	@$(REDIS_CLI) CONFIG GET stream-node-max-bytes

test-entries:
	# 添加 101 个条目到 stream 中
	for i in `seq 1 101`; do \
		$(REDIS_CLI) XADD $(STREAM_NAME) "*" message hello$$i; \
	done
	LENGTH=$$($(REDIS_CLI) XLEN $(STREAM_NAME)); \
	echo "Stream length: $$LENGTH"
	NODES=$$($(REDIS_CLI) XINFO STREAM $(STREAM_NAME) | grep -oP 'radix-tree-nodes:\K\d+'); \
	echo "Number of nodes: $$NODES"

internal-encoding:
	@$(REDIS_CLI) XADD $@ "*" message hello
	@$(REDIS_CLI) OBJECT ENCODING $@

# 向名为 $(STREAM_NAME) 的 stream 中添加一个新的元素，元素的字段名为 "message"，字段值为 "hello"
xadd:
	$(REDIS_CLI) XADD $(STREAM_NAME) "*" message hello

# 获取名为 $(STREAM_NAME) 的 stream 中的元素数量
xlen:
	$(REDIS_CLI) XLEN $(STREAM_NAME)

# 获取名为 $(STREAM_NAME) 的 stream 中的所有元素，"-" 和 "+" 表示获取所有元素
xrange:
	$(REDIS_CLI) XRANGE $(STREAM_NAME) - +

# 从名为 $(STREAM_NAME) 的 stream 中读取元素，"0" 表示从最早的元素开始读取
xread:
	$(REDIS_CLI) XREAD STREAMS $(STREAM_NAME) 0

# 创建一个名为 $(GROUP_NAME) 的消费者组，该组关联的 stream 名为 $(STREAM_NAME)，并设置消费者组的最早未确认消息的 ID 为 0
xgroup:
	$(REDIS_CLI) XGROUP CREATE $(STREAM_NAME) $(GROUP_NAME) 0

# 从名为 $(STREAM_NAME) 的 stream 中读取元素，该 stream 关联的消费者组名为 $(GROUP_NAME)，消费者名为 $(CONSUMER_NAME)，">" 表示读取该消费者未读的消息
xreadgroup:
	$(REDIS_CLI) XREADGROUP GROUP $(GROUP_NAME) $(CONSUMER_NAME) STREAMS $(STREAM_NAME) ">"

# 确认名为 $(GROUP_NAME) 的消费者组已经处理了名为 $(STREAM_NAME) 的 stream 中 ID 为 0 的消息
# 如果消费者收到了消息处理完了但是没有回复 ack，就会导致 PEL 列表不断增长，如果有很多消费组的话，那么这个 PEL 占用的内存就会放大。
xack:
	$(REDIS_CLI) XACK $(STREAM_NAME) $(GROUP_NAME) 0

# 查看名为 $(GROUP_NAME) 的消费者组中名为 $(STREAM_NAME) 的 stream 的待处理消息
xpending:
	$(REDIS_CLI) XPENDING $(STREAM_NAME) $(GROUP_NAME)

# 改变名为 $(GROUP_NAME) 的消费者组中名为 $(STREAM_NAME) 的 stream 的 ID 为 0 的消息的所有权，新的消费者名为 $(CONSUMER_NAME)，并设置该消息的闲置时间为 3600000 毫秒
xclaim:
	$(REDIS_CLI) XCLAIM $(STREAM_NAME) $(GROUP_NAME) $(CONSUMER_NAME) 3600000 0

# 删除名为 $(STREAM_NAME) 的 stream 中 ID 为 0 的元素
xdel:
	$(REDIS_CLI) XDEL $(STREAM_NAME) 0

# 裁剪名为 $(STREAM_NAME) 的 stream，使其最多只包含 1000 个元素
xtrim:
	$(REDIS_CLI) XTRIM $(STREAM_NAME) MAXLEN 100

# 获取名为 $(STREAM_NAME) 的 stream 的信息
xinfo:
	$(REDIS_CLI) XINFO STREAM $(STREAM_NAME)
