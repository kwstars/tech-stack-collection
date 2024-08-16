
.PHONY: all certs clean server client

# 生成证书
certs:
	bash certs/run.sh

# 删除使用 cfssl生成的证书和 keylog.txt
clean:
	rm -f certs/*.pem certs/*.csr keylog.txt

# 启动 server
server:
	go run main.go

# 启动 client
client:
	cd client; go run client.go