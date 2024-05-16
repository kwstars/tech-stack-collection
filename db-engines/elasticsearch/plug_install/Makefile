IMAGE_NAME=my-es-image
CONTAINER_NAME=my-es

.PHONY: build run check clean help

# https://www.elastic.co/guide/en/elasticsearch/plugins/7.17/plugin-management.html

build:
	docker build -t $(IMAGE_NAME) .

run:
	@if [ -z "`docker ps -q`" ]; then echo "Docker is not running, please start Docker"; exit 1; fi
	docker run -it -d --rm --name $(CONTAINER_NAME) -p 9200:9200 -p 9300:9300 -e "discovery.type=single-node" $(IMAGE_NAME)

# 需要等待一段时间，直到插件安装完成
check1:
	@curl -X GET "localhost:9200/_cat/plugins?v"

check2:
	docker exec -it $(CONTAINER_NAME) elasticsearch-plugin list

clean:
	docker stop $(CONTAINER_NAME)
	docker rmi $(IMAGE_NAME)

help:
	@echo "Makefile commands:"
	@echo "build - Build the Docker image."
	@echo "run   - Run the Docker container."
	@echo "check - Check the installed Elasticsearch plugins."
	@echo "clean - Stop the Docker container and remove the Docker image."
