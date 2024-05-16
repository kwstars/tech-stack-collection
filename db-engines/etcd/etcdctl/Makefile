ETCDCTL = export ETCDCTL_API=3; docker exec -it etcd etcdctl --endpoints=127.0.0.1:2379 --command-timeout=5s

# PUT 设置或者更新某个键的值
put:
	$(ETCDCTL) put /test/foo1 "Hello world"
	$(ETCDCTL) put /test/foo2 "Hello world2"
	$(ETCDCTL) put /test/foo3 "Hello world3"

# GET 获取指定键的值
get:
	$(ETCDCTL) get /test/foo3

# 以十六进制格式返回
get_hex:
	$(ETCDCTL) get /test/foo3 --hex

# GET 范围内的值（前开后闭）
get_range:
	$(ETCDCTL) get /test/foo1 /test/foo3

# 通过 --prefix 可以指定前缀
get_prefix:
	$(ETCDCTL) get --prefix /test/foo

# 通过 --limit=2 限制获取的数量
get_limit:
	$(ETCDCTL) get --prefix --limit=2 /test/foo

# https://github.com/etcd-io/etcd/issues/6518
get_rev:
	$(ETCDCTL) put foo11 bar
	$(ETCDCTL) get foo11 --write-out=json
