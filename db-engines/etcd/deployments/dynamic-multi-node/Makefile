set-dynamic:
	curl -X PUT http://10.0.10.10:2379/v2/keys/discovery/6c007a14875d53d9bf0ef5a6fc0257c817fofb83/_config/size -d value=3

get-dynamic:
	curl -L http://discovery.etcd.io/new\?size\=3

check:
	/opt/etcd/bin/etcdctl -endpoints="http://192.168.202.128:2379,http://192.168.202.129:2379,http://192.168.202.130:2379" endpoint health
