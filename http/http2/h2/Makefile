IMAGE_NAME=h2
CONTAINER_NAME=h2-container
HOST_PCAP_DIR = /tmp
CONTAINER_PCAP_DIR = /pcap

# 定义命令
build:
	docker build -t $(IMAGE_NAME) .

run:
	docker run -d -p 443:443 --name $(CONTAINER_NAME) -v $(HOST_PCAP_DIR):$(CONTAINER_PCAP_DIR) $(IMAGE_NAME)

stop:
	docker stop $(CONTAINER_NAME)

remove: stop
	docker rm $(CONTAINER_NAME)

rebuild: stop remove build run

# 生成基于 RSA 的自签名证书
# `openssl req`: 这是 OpenSSL 的一个子命令，用于处理证书签名请求（CSR）。
# `-x509`: 这个选项告诉 OpezznSSL 生成一个自签名的证书，而不是生成一个证书签名请求。这意味着这个证书不需要由证书颁发机构（CA）签名，而是由自己签名。
# `-nodes`: 这个选项告诉 OpenSSL 不要对生成的私钥进行加密。如果不使用这个选项，OpenSSL 会要求你输入一个密码，用于加密私钥。
# `-days 365`: 这个选项设置了证书的有效期。在这个例子中，证书的有效期是 365 天。
# `-newkey rsa:2048`: 这个选项告诉 OpenSSL 生成一个新的 RSA 私钥。`rsa:2048` 指定了私钥的长度，即 2048 位。
# `-keyout nginx.key`: 这个选项指定了私钥的输出文件名。
# `-out nginx.crt`: 这个选项指定了证书的输出文件名。
# `-subj "/C=US/ST=Denial/L=Springfield/O=Dis/CN=www.example.com"`: 这个选项设置了证书的主题，包括国家（C）、州或省份（ST）、地点（L）、组织（O）和通用名（CN）。在这个例子中，通用名被设置为 `www.example.com`。
rsa_ssl:
		openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout nginx.key -out nginx.crt -subj "/C=US/ST=Denial/L=Springfield/O=Dis/CN=www.example.com"

# 生成基于椭圆曲线的自签名证书
ec_ssl:
		openssl ecparam -genkey -name secp384r1 -noout -out nginx.key
		openssl req -new -x509 -key nginx.key -out nginx.crt -days 365 -subj "/C=US/ST=Denial/L=Springfield/O=Dis/CN=www.example.com"

# `-k` 或 `--insecure` 选项允许 curl 接受任何服务器证书，这对于测试自签名证书非常有用。
# --http2 选项告诉 curl 尝试使用 HTTP/2 协议，但如果服务器不支持 HTTP/2，curl 会回退到 HTTP/1.1。
test_http:
	curl -k --http2 -H "Host: www.example.com" https://127.0.0.1:443

test_http2:
	SSLKEYLOGFILE=/tmp/keys.log curl -k -v --http2-prior-knowledge -H "Host: www.example.com" https://127.0.0.1:443