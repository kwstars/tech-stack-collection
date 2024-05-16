REDIS_CLI = docker exec redis redis-cli

# 添加指定元素到 HyperLogLog 中
pfadd:
	$(REDIS_CLI) PFADD myloglog element1 element2 element3

# 返回给定 HyperLogLog 的基数估算值
pfcount:
	$(REDIS_CLI) PFCOUNT myloglog

# 将多个 HyperLogLog 合并为一个 HyperLogLog
pfmerge:
	$(REDIS_CLI) PFMERGE mergedloglog myloglog1 myloglog2
