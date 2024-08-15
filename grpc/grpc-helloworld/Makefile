COMPOSE = docker-compose
DOCKER = docker

.PHONY: all
all: up

.PHONY: up
up:
	$(COMPOSE) up -d

.PHONY: down
down:
	$(COMPOSE) down

.PHONY: rebuild
rebuild:
	$(COMPOSE) build
	$(COMPOSE) up -d

.PHONY: clean
clean:
	$(COMPOSE) rm -sfv
	$(DOCKER) image rm grpc-helloworld-server1 grpc-helloworld-server2 grpc-helloworld-client

.PHONY: logs
logs:
	$(COMPOSE) logs -f

.PHONY: restart-server1
restart-server1:
	$(COMPOSE) restart server1

.PHONY: restart-server2
restart-server2:
	$(COMPOSE) restart server2

.PHONY: restart-client
restart-client:
	$(COMPOSE) restart client

.PHONY: shell-server1
shell-server1:
	$(DOCKER) exec -it server1 /bin/sh

.PHONY: shell-server2
shell-server2:
	$(DOCKER) exec -it server2 /bin/sh

.PHONY: shell-client
shell-client:
	$(DOCKER) exec -it client /bin/sh

.PHONY: help
help:
	@echo "Available targets:"
	@echo "  up              - Start all services"
	@echo "  down            - Stop and remove all containers"
	@echo "  rebuild         - Rebuild and start all services"
	@echo "  clean           - Remove all containers and images"
	@echo "  logs            - Show logs for all containers"
	@echo "  restart-server1 - Restart server1"
	@echo "  restart-server2 - Restart server2"
	@echo "  restart-client  - Restart client"
	@echo "  shell-server1   - Open a shell in server1"
	@echo "  shell-server2   - Open a shell in server2"
	@echo "  shell-client    - Open a shell in client"
	@echo "  help            - Show this help message"