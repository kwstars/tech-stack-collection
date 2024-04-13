# 定义变量
IMAGE_NAME = form-data
CONTAINER_NAME = form-data-container
HOST_PCAP_DIR = /tmp
CONTAINER_PCAP_DIR = /pcap

# 定义命令
build:
	docker build -t $(IMAGE_NAME) .

# run:
# 	docker run -d -p 3000:3000 --name $(CONTAINER_NAME) $(IMAGE_NAME)
run:
	docker run -d -p 3000:3000 --name $(CONTAINER_NAME) -v $(HOST_PCAP_DIR):$(CONTAINER_PCAP_DIR) $(IMAGE_NAME) sh -c "tcpdump -i any -s 0 -w $(CONTAINER_PCAP_DIR)/output.pcap port 3000 & npm start"

stop:
	docker stop $(CONTAINER_NAME)

remove:
	docker rm $(CONTAINER_NAME)

rebuild: stop remove build run