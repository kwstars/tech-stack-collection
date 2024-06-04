# 定义变量
IMAGE_NAME = http-caching
CONTAINER_NAME = http-caching-container
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

test-s-maxage:
	curl -I http://localhost:3000/s-maxage

test-max-age:
	curl -I http://localhost:3000/max-age

test-expires:
	curl -I http://localhost:3000/expires

test-last-modified:
	curl -I http://localhost:3000/last-modified

# 向服务器发送指令，明确指出客户端不会接受 Age 超过 max-age 秒生命周期的缓存。
test-cache-max-age:
	curl -I -H 'Cache-Control: max-age=60' http://localhost:3000

# 这个指令告诉服务器，即使缓存的响应已经过期，只要过期时间不超过 60 秒，客户端仍然愿意接受这个响应。
# 工作流程如下：
# 1. 客户端发送带有 'Cache-Control: max-stale=60' 的请求到代理服务器。
# 2. 代理服务器收到请求后，首先检查它的缓存。
# 3. 如果缓存中有一个匹配的响应，但是这个响应已经过期，代理服务器会检查这个响应过期的时间。
# 4. 如果响应过期的时间不超过 60 秒，代理服务器会将这个响应返回给客户端。
# 5. 如果响应过期的时间超过 60 秒，或者代理服务器没有匹配的缓存，它会将请求转发到源服务器，并将源服务器的响应返回给客户端。
# 6. 如果 max-stale 后没有值，则表示无论过期多久客户端都可使用
test-cache-max-stale:
	curl -I -H 'Cache-Control: max-stale=60' http://localhost:3000

# 这个指令告诉服务器，客户端希望获取的响应至少在未来 60 秒内仍然新鲜。
# 工作流程如下：
# 1. 客户端发送带有 'Cache-Control: min-fresh=60' 的请求到代理服务器。
# 2. 代理服务器收到请求后，首先检查它的缓存。
# 3. 如果缓存中有一个匹配的响应，代理服务器会检查这个响应的剩余新鲜度（即从现在开始到响应过期的时间）。
# 4. 如果响应的剩余新鲜度至少为 60 秒，代理服务器会将这个响应返回给客户端。
# 5. 如果响应的剩余新鲜度少于 60 秒，或者代理服务器没有匹配的缓存，它会将请求转发到源服务器，并将源服务器的响应返回给客户端。
test-cache-min-fresh:
	curl -I -H 'Cache-Control: min-fresh=60' http://localhost:3000

# 这个指令告诉服务器，不能直接使用已有缓存作为响应返回，除非带着缓存条件到上游服务端得到304验证返回码才可使用现有缓存。
# 工作流程如下：
# 1. 客户端发送带有 'Cache-Control: no-cache' 的请求到代理服务器。
# 2. 代理服务器收到请求后，首先检查它的缓存。
# 3. 代理服务器不能直接使用缓存响应，而是带着缓存验证信息（如 ETag 或 Last-Modified）向源服务器发送验证请求。
# 4. 如果源服务器返回304（Not Modified）状态码，代理服务器会更新缓存的头部信息，并将缓存响应返回给客户端。
# 5. 如果源服务器返回200（OK）状态码和新的响应，代理服务器会更新缓存，并将新的响应返回给客户端。
# 这个机制确保客户端获取的响应是最新的，即使这需要代理服务器与源服务器进行额外的通信。
test-cache-no-cache:
	curl -I -H 'Cache-Control: no-cache' http://localhost:3000

# 这个指令告诉服务器，客户端或代理服务器不能存储这个响应的任何部分，即使响应是可缓存的。
# 工作流程如下：
# 1. 客户端发送带有 'Cache-Control: no-store' 的请求到代理服务器。
# 2. 代理服务器收到请求后，不会检查它的缓存，因为 'no-store' 指令禁止使用缓存。
# 3. 代理服务器将请求转发到源服务器，并将源服务器的响应返回给客户端。
# 4. 代理服务器和客户端都不会存储这个响应的任何部分。
# 这个机制用于处理敏感信息，确保这些信息不会被无意中存储或泄露。
test-cache-no-store:
	curl -I -H 'Cache-Control: no-store' http://localhost:3000

# 这个指令告诉服务器，代理服务器不能改变响应的媒体类型。
# 工作流程如下：
# 1. 客户端发送带有 'Cache-Control: no-transform' 的请求到代理服务器。
# 2. 代理服务器收到请求后，首先检查它的缓存。
# 3. 如果缓存中有一个匹配的响应，代理服务器会将这个响应返回给客户端，而不进行任何转换。
# 4. 如果代理服务器没有匹配的缓存，它会将请求转发到源服务器，并将源服务器的响应返回给客户端，同样不进行任何转换。
# 这个机制确保响应的媒体类型不会被代理服务器改变，保持了响应的原始性。
test-cache-no-transform:
	curl -I -H 'Cache-Control: no-transform' http://localhost:3000

# 这个指令告诉服务器，客户端只接受代理服务器的缓存响应，如果没有缓存，代理服务器应返回504（Gateway Timeout）状态码。
# 工作流程如下：
# 1. 客户端发送带有 'Cache-Control: only-if-cached' 的请求到代理服务器。
# 2. 代理服务器收到请求后，首先检查它的缓存。
# 3. 如果缓存中有一个匹配的响应，代理服务器会将这个响应返回给客户端。
# 4. 如果代理服务器没有匹配的缓存，它会返回504（Gateway Timeout）状态码，而不是将请求转发到源服务器。
# 这个机制在网络连接不稳定或者源服务器不可用的情况下可以提高用户体验，因为它避免了长时间等待源服务器的响应。
test-cache-only-if-cached:
	curl -I -H 'Cache-Control: only-if-cached' http://localhost:3000

# 测试缓存 404 响应
test-cache-404:
	curl -I -H 'Cache-Control: public, max-age=3600' http://localhost:3000/not-found

# 测试缓存 206 响应
test-cache-206:
	curl -I -H 'Cache-Control: public, max-age=3600' http://localhost:3000/partial-content