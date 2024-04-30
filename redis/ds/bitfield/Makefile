REDIS_CLI = docker exec redis redis-cli

# 结果: 10100000, 1010 是 10，后面的 0 是填充
u-key:
	$(REDIS_CLI) BITFIELD $@ SET u4 0 10  # 输出: 0 获取的是设置前的值
	$(REDIS_CLI) BITFIELD $@ GET u4 0     # 输出: 10

# 结果: 0000000011101000，左8位是偏移, -3 是 11101 后面的 0 是填充
i-key:
	$(REDIS_CLI) BITFIELD $@ SET i5 8 -3
	$(REDIS_CLI) BITFIELD $@ GET i5 8

# 结果: 00110011100000000000010100000000
multi-op-key:
	$(REDIS_CLI) BITFIELD $@ SET u3 6 7 SET u4 0 3 SET i6 20 20
	$(REDIS_CLI) BITFIELD $@ GET u3 6 GET u4 0 GET i6 20

# 在二进制中，有符号8位整数 100 的表示是 01100100，有符号8位整数 -50 的表示是 11001110（补码表示法）。
# "#1" 和 "#2" 相对于前面命令的偏移量
# 结果: 01100100 11001110
hash-key:
	$(REDIS_CLI) BITFIELD $@ SET i8 "#0" 100 SET i8 "#1" -50
	$(REDIS_CLI) BITFIELD $@ GET i8 "#0" GET i8 "#1"

# 默认的溢出模式 WRAP，环绕处理，适用于有符号和无符号整数。在无符号整数的情况下，环绕就像对整数可以包含的最大值执行模运算（C标准行为）。
# 对于有符号整数，环绕意味着溢出会重新开始向最负的值，下溢则向最正的值，所以例如，如果一个i8整数被设置为值127，增加它1将产生-128。
set-incrby-key:
	$(REDIS_CLI) BITFIELD incrby-key SET u8 0 255
incrby-key:
	$(REDIS_CLI) BITFIELD $@ INCRBY u8 0 1

# 使用饱和算术，也就是说，当发生下溢时，值会被设置为最小整数值，当发生上溢时，值会被设置为最大整数值。
# 例如，从120开始对一个i8整数进行增量为10的增加，结果将变为127，进一步的增加将始终保持值为127。同样的情况也会发生在下溢，但值会被限制在最负的值。
overflow-sat:
	$(REDIS_CLI) BITFIELD $@ OVERFLOW SAT INCRBY u2 0 1
	$(REDIS_CLI) BITFIELD $@ OVERFLOW SAT INCRBY u2 0 1
	$(REDIS_CLI) BITFIELD $@ OVERFLOW SAT INCRBY u2 0 1
	$(REDIS_CLI) BITFIELD $@ OVERFLOW SAT INCRBY u2 0 1

# 在此模式下，检测到上溢或下溢时不执行任何操作。相应的返回值设置为 NULL 以向调用者发出信号通知。在shell里面是空不是NULL。
overflow-fail:
	$(REDIS_CLI) BITFIELD $@ OVERFLOW FAIL incrby u2 5 1
	$(REDIS_CLI) BITFIELD $@ OVERFLOW FAIL incrby u2 5 1
	$(REDIS_CLI) BITFIELD $@ OVERFLOW FAIL incrby u2 5 1
	$(REDIS_CLI) BITFIELD $@ OVERFLOW FAIL incrby u2 5 1
