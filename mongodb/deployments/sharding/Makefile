init-replica-sets:
	docker-compose up -d
	chmod +x init-replica-sets.sh
	./init-replica-sets.sh

set-chunk-size:
	docker-compose exec mongos1 mongosh --port 27017 --eval "use config; db.settings.updateOne(   { _id: "chunksize" },{ $set: { _id: "chunksize", value: 1 } },{ upsert: true })"

add-shard1:
	docker-compose exec mongos1 mongosh --port 27017 --eval "sh.addShard('shard1-rs/shardsrv1:27018')"

add-shard2:
	docker-compose exec mongos1 mongosh --port 27017 --eval "sh.addShard('shard2-rs/shardsrv4:27018')"

status:
	docker-compose exec mongos1 mongosh --port 27017 --eval "sh.status()"

insert-data:
	docker-compose exec mongos1 mongosh --port 27017 --eval "\
	db = db.getSiblingDB('test'); \
	var bulk = db.data.initializeUnorderedBulkOp(); \
	for (i = 0; i < 20000; i++) { \
		bulk.insert({x: i}); \
	} \
	bulk.execute(); \
	"
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
