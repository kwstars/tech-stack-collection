IMAGE_NAME=http-authentication
CONTAINER_NAME=http-authentication-container

# 定义命令
build:
	docker build -t $(IMAGE_NAME) .

run:
	docker run -d -p 8080:80 --name $(CONTAINER_NAME) $(IMAGE_NAME)

stop:
	docker stop $(CONTAINER_NAME)

remove: stop
	docker rm $(CONTAINER_NAME)

rebuild: stop remove build run
