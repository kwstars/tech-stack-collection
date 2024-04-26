
step1:
	docker-compose up -d

# https://www.mongodb.com/docs/manual/reference/method/rs.initiate/
step2:
	docker-compose exec mongo1 mongosh --eval "rs.initiate({ _id: 'rs0', members: [{ _id: 0, host: 'mongo1:27017' }, { _id: 1, host: 'mongo2:27017' }, { _id: 2, host: 'mongo3:27017' } ] })"

rs_help:
	docker-compose exec mongo1 mongosh --eval "rs.help()"

check_status:
	docker-compose exec mongo1 mongosh --eval "rs.status()"

show_rs_config:
	docker-compose exec mongo1 mongosh --eval "rs.conf()"

# https://www.mongodb.com/docs/manual/reference/method/rs.remove/
remove_member:
	docker-compose exec mongo1 mongosh --eval "rs.remove('mongo3:27017')"

# https://www.mongodb.com/docs/manual/reference/method/rs.add/
add_member:
	docker-compose exec mongo1 mongosh --eval "rs.add('mongo3:27017')"

# https://www.mongodb.com/docs/manual/reference/method/rs.stepDown/
# rs.stepDown() 方法并不会立即使主节点降级。如果没有可选的从节点与主节点同步，主节点会等待最多 secondaryCatchUpPeriodSecs（默认为 10 秒）以让从节点赶上。一旦有可选的从节点可用，方法就会使主节点降级。
# 一旦降级，原主节点变为从节点，并在 stepDownSecs 指定的剩余时间内无法再次成为主节点。
primary_to_secondary:
	docker-compose exec mongo1 mongosh --eval "rs.stepDown()"

show_config:
	docker-compose exec mongo1 mongosh --eval "db.adminCommand({ getParameter: '*' })"
