REDIS_MASTER_CLI = docker-compose exec redis-master redis-cli
REDIS_SLAVE_CLI = docker-compose exec redis-slave redis-cli

# 使当前 Redis 服务器成为地址为 127.0.0.1，端口为 6379 的 Redis 服务器的从服务器。
set-slave:
    $(REDIS_SLAVE_CLI) SLAVEOF 127.0.0.1 6379

# 使当前 Redis 服务器停止作为其他服务器的从服务器，即将其从从服务器变为主服务器。
remove-slave:
    $(REDIS_SLAVE_CLI) SLAVEOF NO ONE

# 用于获取当前服务器的复制信息，包括主从服务器的状态、复制偏移量等。
info-replication-master:
	$(REDIS_MASTER_CLI) INFO REPLICATION

info-replication-slave:
	$(REDIS_SLAVE_CLI) INFO REPLICATION

# 用于获取当前服务器的只读设置。在默认情况下，从服务器是只读的。
get-read-only:
	$(REDIS_SLAVE_CLI) CONFIG GET slave-read-only

# 用于取消当前服务器的只读设置，使其可以进行写操作。
set-read-write:
	$(REDIS_SLAVE_CLI) CONFIG SET slave-read-only no

set-read-only:
	$(REDIS_SLAVE_CLI) CONFIG SET slave-read-only yes

# 在 master 写入
write:
	$(REDIS_MASTER_CLI) set foo bar

# 在 slave 查看
read:
	$(REDIS_SLAVE_CLI) get foo

clean:
	docker-compose rm -sf
	docker volume rm master-slave_redis-master-data master-slave_redis-slave-data
