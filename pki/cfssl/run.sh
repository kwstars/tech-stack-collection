#!/bin/bash

set -euvo pipefail

# Get the directory of the current script
script_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
cd "$script_dir"

# https://github.com/cloudflare/cfssl
# go install github.com/cloudflare/cfssl/cmd/...@latest

# 根据 ca-csr.json 文件生成 CA 证书和私钥，并将它们写入到 ca.pem 和 ca-key.pem 文件中。
# - `C`：Country（国家），这是国家的两字母 ISO 3166 代码。
# - `L`：Locality（地点），这通常是城市或者地区的名称。
# - `O`：Organization（组织），这是你的公司或者组织的名称。
# - `ST`：State or Province（州或省份），这是州或省份的全名。
# - `OU`：Organizational Unit（组织单位），这是你的公司内部的部门或者团队的名称。
cfssl gencert -initca ca-csr.json | cfssljson -bare ca

# 根据 server-csr.json 文件生成服务器证书和私钥，并将它们写入到 server.pem 和 server-key.pem 文件中。
cfssl gencert -ca=ca.pem -ca-key=ca-key.pem -config=ca-config.json -profile etcd server-csr.json | cfssljson -bare server

# openssl x509 -in ca.pem -text -noout
# openssl x509 -in server.pem -text -noout
