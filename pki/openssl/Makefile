.PHONY: all
all: server.crt

# 生成 CA 私钥
ca.key:
	openssl genrsa -out ca.key 2048

# 生成 CA 证书
ca.crt: ca.key
	openssl req -x509 -new -nodes -key ca.key -sha256 -days 1825 -out ca.crt -subj "/C=US/ST=California/L=San Francisco/O=Your Company Name/CN=yourcompany.com"

# 生成服务器私钥
server.key:
	openssl genrsa -out server.key 2048

# 生成证书签名请求（CSR）
server.csr: server.key
	openssl req -new -key server.key -out server.csr -subj "/C=US/ST=California/L=San Francisco/O=Your Company Name/CN=yourserver.yourcompany.com"

# 生成服务器证书
server.crt: server.csr ca.crt ca.key
	openssl x509 -req -in server.csr -CA ca.crt -CAkey ca.key -CAcreateserial -out server.crt -days 1825 -sha256

# 验证证书
verify: server.crt ca.crt
	openssl verify -CAfile ca.crt server.crt

# 显示证书信息
show: server.crt
	openssl x509 -in server.crt -text -noout

# 显示证书公钥
pubkey: server.crt
	openssl x509 -pubkey -noout -in server.crt

# 显示 CSR 信息
csr: server.csr
	openssl req -text -noout -verify -in server.csr

# 检查私钥
check: server.key
	openssl rsa -check -in server.key

clean:
	rm -f ca.key ca.crt server.key server.csr server.crt
