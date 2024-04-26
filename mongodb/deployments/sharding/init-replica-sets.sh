#!/bin/bash

docker-compose exec configsvr1 mongosh --port 27019 --eval "\
try { \
  rs.status(); \
  print('Replica set already initialized'); \
} catch (err) { \
  rs.initiate({ _id: 'config-rs', members: [{ _id: 0, host: 'configsvr1:27019' }] }); \
  print('Replica set initialized'); \
}"

docker-compose exec shardsrv1 mongosh --port 27018 --eval "\
try { \
  rs.status(); \
  print('Replica set already initialized'); \
} catch (err) { \
  rs.initiate({ _id:'shard1-rs', members: [{ _id: 0, host: 'shardsrv1:27018' }] }); \
  print('Replica set initialized'); \
}"

docker-compose exec shardsrv4 mongosh --port 27018 --eval "\
try { \
  rs.status(); \
  print('Replica set already initialized'); \
} catch (err) { \
  rs.initiate({ _id:'shard2-rs', members: [{ _id: 0, host: 'shardsrv4:27018' }] }); \
  print('Replica set initialized'); \
}"
