IMAGE_NAME=h2c
CONTAINER_NAME=h2c-container
HOST_PCAP_DIR = /tmp
CONTAINER_PCAP_DIR = /pcap

# 定义命令
build:
	docker build -t $(IMAGE_NAME) .

run:
	docker run -d -p 8080:80 --name $(CONTAINER_NAME) -v $(HOST_PCAP_DIR):$(CONTAINER_PCAP_DIR) $(IMAGE_NAME)

stop:
	docker stop $(CONTAINER_NAME)

remove: stop
	docker rm $(CONTAINER_NAME)

rebuild: stop remove build run

# 大多数现代浏览器（包括 Chrome）不支持 h2c，因为他们默认使用加密的 HTTP/2（h2）。这是因为浏览器厂商希望推动全网的加密，因此他们决定只支持加密的 HTTP/2。
# --http2-prior-knowledge 选项，它告诉 curl 只使用 HTTP/2 协议进行请求，而不进行协议协商或回退到 HTTP/1.1。这个选项应该只在你知道服务器肯定支持 HTTP/2 的情况下使用。
h2c:
	curl -v --http2-prior-knowledge http://localhost:8080