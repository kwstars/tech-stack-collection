# 定义变量
IMAGE_NAME = http-conditional-requests
CONTAINER_NAME = http-conditional-requests-container
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

# ------ Cache update ------
# 首次请求
first-time-cache:
	curl -v http://localhost:3000/first-time-cache

# 验证缓存成功
validate-cache-success:
	# curl -v -H 'If-Modified-Since: ' -H 'If-None-Match: "12345"' http://localhost:3000/validate-cache
	curl -v -H 'If-Modified-Since: Tue, 15 Nov 1994 12:45:26 GMT' -H 'If-None-Match: "12345"' http://localhost:3000/validate-cache

# 验证缓存失败
validate-cache-failure:
	curl -v http://localhost:3000/validate-cache

# ------Integrity of a partial download ------
first_3_bytes:
	curl -i -H "Range: bytes=0-2" http://localhost:3000/partial

second_2_bytes:
	curl -i -H 'Range: bytes=3-4' -H 'If-None-Match: W/"3-28LR/tDcN6cK6g83aVjIAu3cBVk"' http://localhost:3000/partial

second_2_bytes_failure:
	curl -i -H "Range: bytes=3-4" -H 'If-None-Match: W/"3-28LR/tDcN6cK6g83aVjIAu3cBVk"' http://localhost:3000/partial


# ------ Avoiding the lost update problem with optimistic locking ------


# ------ Dealing with the first upload of a resource ------
