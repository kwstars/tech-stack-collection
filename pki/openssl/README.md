**生成私钥**

```bash
openssl genpkey -algorithm RSA -out ca.key
```

**生成自签名证书**

```bash
openssl req -x509 -new -nodes -key ca.key -sha256 -days 1024 -out ca.crt
```

**生成证书签名请求（CSR）**

```bash
openssl req -new -key server.key -out server.csr
```

**使用 CA 签名 CSR**

```bash
openssl x509 -req -in server.csr -CA ca.crt -CAkey ca.key -CAcreateserial -out server.crt -days 500 -sha256
```

**验证证书**

```bash
openssl verify -CAfile ca.crt server.crt
```

**查看证书信息**

```bash
openssl x509 -in server.crt -text -noout
```

**查看 CSR 信息**

```bash
openssl req -text -noout -verify -in server.csr
```

**检查私钥**

```bash
openssl rsa -check -in server.key
```

**加密私钥**

```bash
openssl rsa -in server.key -aes256 -out server.key.new
```

**生成 Diffie-Hellman 参数**

```bash
openssl dhparam -out dhparam.pem 2048
```

**创建证书吊销列表（CRL）**

```bash
openssl ca -config ca.conf -gencrl -out crl.pem
```

**更新 CRL**

```bash
openssl ca -config ca.conf -updatedb
```

将 RSA 的私钥生成公钥

```bash
openssl rsa -pubout -in private_key.pem -out public_key.pem
```

将 ES 或 DSA 的私钥生成公钥

```bash
openssl pkey -pubout -in private_key.pem -out public_key.pem
```
