# https://github.com/cloudflare/cfssl

install:
	go install github.com/cloudflare/cfssl/cmd/...@latest

# 根据 ca-csr.json 文件生成 CA 证书和私钥，并将它们写入到 ca.pem 和 ca-key.pem 文件中。
ca:
	cfssl gencert -initca ca-csr.json | cfssljson -bare ca

# 根据 server-csr.json 文件生成服务器证书和私钥，并将它们写入到 server.pem 和 server-key.pem 文件中。
cert: ca
	cfssl gencert -ca=ca.pem -ca-key=ca-key.pem -config=ca-config.json -profile etcd server-csr.json | cfssljson -bare server

clean:
	rm -f ca-key.pem ca.csr ca.pem server-key.pem server.csr server.pem
