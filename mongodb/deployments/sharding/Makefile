init-replica-sets:
	docker-compose up -d
	chmod +x init-replica-sets.sh
	./init-replica-sets.sh

add-shard1:
	docker-compose exec mongos1 mongosh --port 27017 --eval "sh.addShard('shard1-rs/shardsrv1:27018')"

add-shard2:
	docker-compose exec mongos1 mongosh --port 27017 --eval "sh.addShard('shard2-rs/shardsrv4:27018')"

status:
	docker-compose exec mongos1 mongosh --port 27017 --eval "sh.status()"

insert-data:
	docker-compose exec mongos1 mongosh --port 27017 --eval "db = db.getSiblingDB('test'); for (i = 0; i < 1000; i++) { db.data.insertOne({x: i}) }"

count-data:
	docker-compose exec mongos1 mongosh --port 27017 --eval "db = db.getSiblingDB('test'); db.data.countDocuments()"

shard-collection:
	docker-compose exec mongos1 mongosh --port 27017 --eval "sh.shardCollection('test.data', {_id: 1})"
# shard-collection:
# 	docker-compose exec mongos1 mongosh --port 27017 --eval "db = db.getSiblingDB('test'); db.data.createIndex({_id: 'hashed'}); sh.shardCollection('test.data', {_id: 'hashed'})"

migrate-and-shard:
	docker-compose exec mongos1 mongosh --port 27017 --eval "\
	db = db.getSiblingDB('test'); \
	db.data.find().forEach(function(doc) { \
		db.newData.insertOne(doc); \
	}); \
	db.newData.createIndex({_id: 'hashed'}); \
	sh.shardCollection('test.newData', {_id: 'hashed'}); \
	"

rebanlance:
	docker-compose exec mongos1 mongosh --port 27017 --eval "sh.startBalancer()"

clean:
	docker-compose rm -sf
	docker volume rm sharding_configsvr1 sharding_shardsrv1 sharding_shardsrv4
