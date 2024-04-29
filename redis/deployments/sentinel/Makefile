HOST_IP ?= 10.0.0.8

prepare:
	@echo "Please enter the host IP:"; \
	read host_ip; \
	\cp -f docker-compose-template.yaml docker-compose.yaml; \
	\cp -f sentinel-template.conf sentinel.conf; \
	sed -i "s/<HOST_IP>/$$host_ip/g" docker-compose.yaml; \
	sed -i "s/<HOST_IP>/$$host_ip/g" sentinel.conf

run:
	docker-compose up -d

info-replication:
	@echo "Please enter the Redis server name (redis1, redis2, redis3):"
	@read server_name; \
	docker-compose exec $$server_name redis-cli INFO REPLICATION

info-sentinel:
	@echo "Please enter the Redis sentinel name (sentinel1, sentinel2, sentinel3):"
	@read sentinel_name; \
	docker-compose exec $$sentinel_name redis-cli -p 26379 INFO SENTINEL

clean:
	docker-compose rm -sf
	rm -fr docker-compose.yaml sentinel.conf
	docker volume rm sentinel_redis1-data sentinel_redis2-data sentinel_redis3-data
