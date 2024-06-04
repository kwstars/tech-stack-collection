#!/bin/bash

set -euvo pipefail

run_docker_compose() {
  if command -v docker-compose &>/dev/null; then
    docker-compose "$@" # Use hyphenated version
  elif command -v docker compose &>/dev/null; then
    docker compose "$@" # Use space-separated version
  else
    echo "Error: Neither 'docker-compose' nor 'docker compose' found."
    exit 1 # Exit the script with an error code
  fi
}

# Get the directory of the current script
script_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
cd "$script_dir"

# Generate a private key for the CA
echo "yourpassword" >passwd.txt
openssl genpkey -algorithm RSA -out ca.key -aes256 -pass file:passwd.txt
# Generate a self-signed certificate for the CA
openssl req -x509 -new -nodes -key ca.key -sha256 -days 3650 -out ca.crt -subj "/C=US/ST=State/L=City/O=Organization/OU=OrgUnit/CN=RootCA" -passin file:passwd.txt
# Generate a private key for the server
openssl genpkey -algorithm RSA -out nginx.key
# Generate a certificate signing request (CSR) for the server
openssl req -new -key nginx.key -out nginx.csr -subj "/C=US/ST=State/L=City/O=Organization/OU=OrgUnit/CN=foo.bar.com"
# Create a configuration file for server certificate extensions
# keyid 是颁发者公钥的标识符，issuer 是颁发者的名称。
# basicConstraints=CA:FALSE：这个扩展指定该证书不能被用作 CA（证书颁发机构）。这是因为这个证书是服务器证书，不应该被用来签署其他证书。
# keyUsage = digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment：这个扩展定义了公钥的用途。digitalSignature 表示可以用于数字签名，nonRepudiation 表示可以用于防止否认，keyEncipherment 和 dataEncipherment 表示可以用于加密。
# subjectAltName = @alt_names 和 [alt_names] DNS.1 = foo.bar.com：这些行定义了证书的主题备用名称（Subject Alternative Name，SAN）。SAN 允许你为证书指定多个主机名。在这个例子中，只指定了一个主机名 foo.bar.com。如果你的服务器有多个域名，你可以在这里添加更多的 DNS.x 行。
cat >server_ext.cnf <<EOL
authorityKeyIdentifier=keyid,issuer
basicConstraints=CA:FALSE
keyUsage = digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment
subjectAltName = @alt_names

[alt_names]
DNS.1 = foo.bar.com
EOL
# Use the CA to sign the server certificate
openssl x509 -req -in nginx.csr -CA ca.crt -CAkey ca.key -CAcreateserial -out nginx.crt -days 825 -sha256 -extfile server_ext.cnf -passin file:passwd.txt

#  Generate 2048-bit Diffie-Hellman parameters and save them to dhparam.pem
openssl dhparam -out ./dhparam.pem 2048

# Start the Prometheus and Redis exporter
run_docker_compose up -d

wait_for_services() {
  local services
  services=$(run_docker_compose config --services)

  for service in $services; do
    echo "Waiting for $service to be healthy..."
    while [ "$(docker inspect --format='{{.State.Health.Status}}' "$(run_docker_compose ps -q "$service")")" != "healthy" ]; do
      sleep 2
    done
  done
}

wait_for_services

# --http2-prior-knowledge 可以节省协商过程的时间，但如果服务器不支持 HTTP/2，连接会失败。--http2 更加安全，因为它可以回退到 HTTP/1.1，但可能会稍微慢一些。
# SSLKEYLOGFILE=/mnt/c/Users/Kira/sslkeylog/sslkeylog.log curl -k --http2 -H "Host: foo.bar.com" https://127.0.0.1:443
SSLKEYLOGFILE=/mnt/c/Users/Kira/sslkeylog/sslkeylog.log curl -k -v --http2-prior-knowledge -H "Host: foo.bar.com" https://127.0.0.1:443
