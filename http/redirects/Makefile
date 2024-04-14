# 定义变量
IMAGE_NAME = http-redirects
CONTAINER_NAME = http-redirects-container
HOST_PCAP_DIR = /tmp
CONTAINER_PCAP_DIR = /pcap

# 定义命令
build:
	docker build --target production -t $(IMAGE_NAME) .

run:
	docker run -d -p 3000:3000 --name $(CONTAINER_NAME) -v $(HOST_PCAP_DIR):$(CONTAINER_PCAP_DIR) --init $(IMAGE_NAME) sh -c "tcpdump -i any -s 0 -w $(CONTAINER_PCAP_DIR)/output.pcap port 3000 & npm start"

stop:
	docker stop $(CONTAINER_NAME)

remove: stop
	docker rm $(CONTAINER_NAME)

rebuild: stop remove build run

domain-aliasing:
	curl -I --header "Host: example.com" http://localhost:3000
	curl -I --header "Host: old-example.com" http://localhost:3000

# permanent-redirect:
# 	# 使用 curl 发送一个 POST 请求，并在遇到 301 重定向时自动跟随重定向。
# 	# 请注意，尽管这个命令发送的是 POST 请求，但在 Postman 中，由于 301 重定向的特性，这个请求会被转换为 GET 请求。
# 	curl -L -X POST -d "param=value" http://localhost:3000/old-url-301
# 	curl -L -X POST -H "Content-Type: application/json" -d '{"param":"value"}' http://localhost:3000/old-url-308

# temporary-redirect:
# 	# 游览器中会改成 GET 请求
# 	curl -L -X POST -H "Content-Type: application/json" -d '{"param":"value"}' http://localhost:3000/old-url-302
# 	# 游览器中会改成 GET 请求
# 	curl -L -X POST -H "Content-Type: application/json" -d '{"param":"value"}' http://localhost:3000/old-url-303
# 	# 请求方法和请求体不会改变
# 	curl -L -X POST -H "Content-Type: application/json" -d '{"param":"value"}' http://localhost:3000/old-url-307