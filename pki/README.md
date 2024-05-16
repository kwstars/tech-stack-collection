## Architecture

Public Key Infrastructure (PKI) 主要由以下几个部分组成：

1. **证书颁发机构 (CA)**：证书颁发机构是负责发放、更新和撤销证书的实体。CA 是 PKI 的核心，它可以是一个组织的部分，也可以是一个独立的服务。
2. **注册机构 (RA)**：注册机构是负责验证证书申请者身份的实体。在一些 PKI 系统中，RA 的功能可能会被 CA 承担。
3. **证书**：证书是一个包含公钥和一些身份信息的文件，它由 CA 签名。证书可以用来验证公钥的所有者的身份。
4. **私钥和公钥**：私钥和公钥是 PKI 的基础。私钥是保密的，只有所有者知道。公钥是公开的，可以包含在证书中。私钥和公钥是一对，它们可以用来加密和解密信息，或者生成和验证数字签名。
5. **证书撤销列表 (CRL) 和在线证书状态协议 (OCSP)**：CRL 和 OCSP 是用来检查证书是否被撤销的机制。CRL 是一个包含被撤销证书的列表，OCSP 是一个可以查询证书状态的协议。
6. **证书存储和分发**：证书需要被安全地存储和分发。这通常通过一些专门的系统或服务来实现，例如 LDAP 服务器、HTTP 服务器、硬件安全模块 (HSM) 等。

## 实现

1. **OpenSSL**：这是一个强大的安全套接字层密码库，包含了丰富的命令行工具。你可以使用 OpenSSL 创建和管理证书和密钥。
2. **cfssl**：这是 CloudFlare 开源的 PKI/TLS 工具集，它提供了一个简单的、可配置的、端到端的解决方案来创建自己的证书颁发机构。
3. **EasyRSA**：这是一个基于 OpenSSL 的简单的 CA 工具，可以用来创建和管理证书颁发机构。
4. **step-ca**：这是 smallstep 开源的一个简单、安全、现代的证书颁发机构，可以用来创建和管理证书和密钥。
5. **Vault**：这是 HashiCorp 开源的一个安全工具，可以用来管理密钥、证书和其他敏感数据。Vault 提供了一个 PKI 服务，可以用来创建和管理证书颁发机构。
6. **EJBCA**：这是一个企业级的开源证书颁发机构，提供了丰富的功能和灵活的配置。
7. **dogtag**：这是一个企业级的开源证书系统，提供了证书颁发机构、密钥恢复、证书存储等功能。

## 参考和引用

- [Internet X.509 Public Key Infrastructure Certificate and Certificate Revocation List (CRL) Profile](https://datatracker.ietf.org/doc/html/rfc5280)
- [PKCS #10: Certification Request Syntax Specification Version 1.7](https://datatracker.ietf.org/doc/html/rfc2986)
- [ X.509 Internet Public Key Infrastructure Online Certificate Status Protocol - OCSP](https://datatracker.ietf.org/doc/html/rfc6960)
- [Internet X.509 Public Key Infrastructure Certificate Policy and Certification Practices Framework](https://datatracker.ietf.org/doc/html/rfc3647)
- [Suite B Certificate and Certificate Revocation List (CRL) Profile](https://datatracker.ietf.org/doc/html/rfc5759)
- https://kubernetes.io/docs/tasks/administer-cluster/certificates/
