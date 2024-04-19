.PHONY: run stop remove

run:
	@docker-compose up -d

stop:
	@docker-compose stop

remove:
	@docker-compose rm -sf

ps:
	@docker-compose ps

clean:
	@sudo rm -rf prometheus1_data prometheus2_data

chmod:
	@sudo chmod -R 777 prometheus1_data prometheus2_data
