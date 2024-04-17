.PHONY: run stop remove help install-dashboards

run:
	@docker-compose up -d

stop:
	@docker-compose stop

remove:
	@docker-compose rm -sf

ps:
	@docker-compose ps

install-dashboards:
	@bash install_dashboards.sh

clean:
	@rm -fr dashboards

help:
	@echo "run    - Start the prometheus and node_exporter services."
	@echo "stop   - Stop all services."
	@echo "remove - Remove all stopped containers."
