DOCKER_COMPOSE := $(shell command -v docker-compose 2> /dev/null || echo "docker compose")

init-replica-sets:
	$(DOCKER_COMPOSE) up -d
	chmod +x init-replica-sets.sh && sleep 3
	./init-replica-sets.sh

set-chunk-size:
	$(DOCKER_COMPOSE) exec mongos1 mongosh --port 27017 --eval "use config; db.settings.updateOne(   { _id: "chunksize" },{ $set: { _id: "chunksize", value: 1 } },{ upsert: true })"

add-shard1:
	$(DOCKER_COMPOSE) exec mongos1 mongosh --port 27017 --eval "sh.addShard('shard1-rs/shardsrv1:27018')"

add-shard2:
	$(DOCKER_COMPOSE) exec mongos1 mongosh --port 27017 --eval "sh.addShard('shard2-rs/shardsrv4:27018')"

status:
	$(DOCKER_COMPOSE) exec mongos1 mongosh --port 27017 --eval "sh.status()"

insert-data:
	$(DOCKER_COMPOSE) exec mongos1 mongosh --port 27017 --eval "\
	db = db.getSiblingDB('test'); \
	var bulk = db.data.initializeUnorderedBulkOp(); \
	for (i = 0; i < 20000; i++) { \
		bulk.insert({x: i}); \
	} \
	bulk.execute(); \
	"
count-data:
	$(DOCKER_COMPOSE) exec mongos1 mongosh --port 27017 --eval "db = db.getSiblingDB('test'); db.data.countDocuments()"

shard-collection:
	$(DOCKER_COMPOSE) exec mongos1 mongosh --port 27017 --eval "sh.shardCollection('test.data', {_id: 1})"
# shard-collection:
# 	$(DOCKER_COMPOSE) exec mongos1 mongosh --port 27017 --eval "db = db.getSiblingDB('test'); db.data.createIndex({_id: 'hashed'}); sh.shardCollection('test.data', {_id: 'hashed'})"

migrate-and-shard:
	$(DOCKER_COMPOSE) exec mongos1 mongosh --port 27017 --eval "\
	db = db.getSiblingDB('test'); \
	db.data.find().forEach(function(doc) { \
		db.newData.insertOne(doc); \
	}); \
	db.newData.createIndex({_id: 'hashed'}); \
	sh.shardCollection('test.newData', {_id: 'hashed'}); \
	"

rebanlance:
	$(DOCKER_COMPOSE) exec mongos1 mongosh --port 27017 --eval "sh.startBalancer()"

clean:
	$(DOCKER_COMPOSE) rm -sf
	docker volume rm sharding_configsvr1 sharding_shardsrv1 sharding_shardsrv4
