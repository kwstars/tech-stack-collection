DOCKER_COMPOSE := $(shell command -v docker-compose 2> /dev/null || echo "docker compose")

prepare:
	@echo "Please enter the host IP:"; \
	read host_ip; \
	\cp -f docker-compose-template.yaml docker-compose.yaml; \
	\cp -f sentinel-template.conf sentinel.conf; \
	sed -i "s/<HOST_IP>/$$host_ip/g" docker-compose.yaml; \
	sed -i "s/<HOST_IP>/$$host_ip/g" sentinel.conf

run:
	$(DOCKER_COMPOSE) up -d

info-replication1:
	$(DOCKER_COMPOSE) exec redis1 redis-cli -p 16379 INFO REPLICATION

info-replication2:
	$(DOCKER_COMPOSE) exec redis2 redis-cli -p 26379 INFO REPLICATION

info-replication3:
	$(DOCKER_COMPOSE) exec redis3 redis-cli -p 36379 INFO REPLICATION

info-sentinel1:
	$(DOCKER_COMPOSE) exec sentinel3 redis-cli -p 26379 INFO SENTINEL

info-sentinel2:
	$(DOCKER_COMPOSE) exec sentinel3 redis-cli -p 26379 INFO SENTINEL

info-sentinel3:
	$(DOCKER_COMPOSE) exec sentinel3 redis-cli -p 26379 INFO SENTINEL

clean:
	$(DOCKER_COMPOSE) rm -sf
	rm -fr docker-compose.yaml sentinel.conf
	docker volume rm sentinel_redis1-data sentinel_redis2-data sentinel_redis3-data
