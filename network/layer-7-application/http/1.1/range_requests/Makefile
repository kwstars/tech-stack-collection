IMAGE_NAME=http-range-requests
CONTAINER_NAME=http-range-requests-container

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

# ------ Single part ranges
# 如果服务器能够满足这个请求，它会返回一个 '206 Partial Content' 响应和请求的字节。
first_5_bytes:
	curl -i -H "Range: bytes=0-4" http://localhost:8080/alphabet.txt

# 这个目标发送一个 HTTP 请求，请求 'alphabet.txt' 文件的第 30 个字节到最后一个字节。
# 如果服务器不能满足这个请求，它会返回一个 '416 Range Not Satisfiable' 响应。
# Content-Range: bytes */26
range_not_satisfiable:
	curl -i -H "Range: bytes=30-" http://localhost:8080/alphabet.txt

second_5_bytes:
	curl -i -H "Range: bytes=5-9" http://localhost:8080/alphabet.txt

# ------ Multipart ranges
multiple_ranges:
	curl -i -H "Range: bytes=1-2,5-6" http://localhost:8080/alphabet.txt

last_2_bytes:
	curl -i -H "Range: bytes=-2" http://localhost:8080/alphabet.txt

first_and_last_bytes:
	curl -i -H "Range: bytes=0-0,-1" http://localhost:8080/alphabet.txt

# ------ Conditional range requests
# 当 ETag 匹配时，服务器会返回请求的资源。这意味着资源没有改变，客户端的缓存版本是最新的。
# 当 ETag 不匹配时，服务器会返回一个 412 Precondition Failed 响应。这意味着资源已经改变，客户端需要重新请求整个资源。
if_match_request:
	curl -i -H "If-Match: \"your-etag-value\"" http://localhost:8080/alphabet.txt
