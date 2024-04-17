.PHONY: run stop remove help

run:
	docker-compose up -d prometheus node_exporter alertmanager grafana

stop:
	docker-compose stop

remove:
	docker-compose rm -sf

ps:
	docker-compose ps

help:
	@echo "run    - Start the prometheus and node_exporter services."
	@echo "stop   - Stop all services."
	@echo "remove - Remove all stopped containers."
