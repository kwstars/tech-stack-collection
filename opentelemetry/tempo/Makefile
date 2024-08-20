.PHONY: build up down request

build:
	docker-compose build --no-cache

up:
	docker-compose up -d

down:
	docker-compose down -v

request:
	curl http://localhost:8000/v1/user/get/message/10
