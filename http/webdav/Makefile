IMAGE_NAME=webdav
CONTAINER_NAME=webdav-container
HOST_PCAP_DIR = /tmp
CONTAINER_PCAP_DIR = /pcap
USERNAME=user
PASSWORD=password

# 定义命令
build:
	docker build -t $(IMAGE_NAME) .

run:
	docker run -d -p 8080:80 --name $(CONTAINER_NAME) -v $(HOST_PCAP_DIR):$(CONTAINER_PCAP_DIR) -e USERNAME=$(USERNAME) -e PASSWORD=$(PASSWORD) $(IMAGE_NAME)

stop:
	docker stop $(CONTAINER_NAME)

remove: stop
	docker rm $(CONTAINER_NAME)

rebuild: stop remove build run
