## [TLS 1.2 握手协议概述](https://datatracker.ietf.org/doc/html/rfc5246#section-7.3)

### Full handshake

```
      Client                                               Server

      ClientHello                  -------->
                                                      ServerHello
                                                     Certificate*
                                               ServerKeyExchange*
                                              CertificateRequest*
                                   <--------      ServerHelloDone
      Certificate*
      ClientKeyExchange
      CertificateVerify*
      [ChangeCipherSpec]
      Finished                     -------->
                                               [ChangeCipherSpec]
                                   <--------             Finished
      Application Data             <------->     Application Data

             Figure 1.  Message flow for a full handshake

   * Indicates optional or situation-dependent messages that are not
   always sent.
```

在 TLS 1.2 中，握手过程可以大致分为以下几个阶段：

1. **Hello 阶段**：

   - 客户端发送 ClientHello 消息，包含支持的 TLS 版本、加密套件列表、随机数等。
   - 服务器回复 ServerHello 消息，确认 TLS 版本、选择加密套件、生成随机数，并可能发送会话 ID。

2. **密钥交换阶段**：

   - 服务器发送 Certificate 消息（可选），为了向客户端提供其身份证明。这个消息包含了服务器的公钥证书，客户端可以使用这个证书来验证服务器的身份，并用于后续的加密操作。
   - 服务器可能发送 ServerKeyExchange 消息（可选），为客户端提供计算预主密钥所需的额外信息，包括服务器的公钥、Diffie-Hellman 参数或椭圆曲线参数等。具体是否发送以及发送的内容取决于选择的密钥交换算法和服务器证书的情况。
   - 客户端发送 ClientKeyExchange 消息（可选），包含预主密钥或计算预主密钥所需的信息。

3. **身份验证阶段**：

   - 服务器可能发送 CertificateRequest 消息，当服务器需要验证客户端身份或选择的加密套件要求客户端认证时。
   - 客户端发送 Certificate 消息（可选），包含其数字证书。
   - 客户端发送 CertificateVerify 消息（可选），证明证书所有权。当客户端发送了带有签名能力的证书时，服务器需要验证客户端是否真正拥有该证书对应的私钥。客户端通过使用私钥对握手消息进行签名，生成 CertificateVerify 消息，并将该消息发送给服务器。服务器使用客户端证书中的公钥验证签名，如果验证通过，则可以确认客户端确实拥有私钥，从而验证客户端的身份。

4. **完成阶段**：
   - 客户端和服务器各自发送 ChangeCipherSpec 消息，表示已切换到协商好的加密参数。
   - 客户端和服务器分别发送 Finished 消息，验证握手过程的完整性。

握手完成后，客户端和服务器可以使用协商好的密钥和加密算法进行安全的应用数据传输。

### Abbreviated handshake

在 TLS 1.2 中，Abbreviated Handshake（简化握手）是一种优化的握手过程，用于在客户端和服务器之间快速建立新的安全连接，前提是双方已经在之前的连接中建立过安全会话。

```
      Client                                                Server

      ClientHello                   -------->
                                                       ServerHello
                                                [ChangeCipherSpec]
                                    <--------             Finished
      [ChangeCipherSpec]
      Finished                      -------->
      Application Data              <------->     Application Data

          Figure 2.  Message flow for an abbreviated handshake
```

以下是 TLS 1.2 简化握手的流程：

1. 客户端发送 ClientHello 消息，包含要恢复的会话 ID。
2. 服务器检查会话缓存，如果找到匹配的会话 ID，则发送 ServerHello 消息，并在消息中包含相同的会话 ID。
3. 客户端和服务器各自发送 ChangeCipherSpec 消息，表示将开始使用新的加密设置。
4. 客户端和服务器各自发送 Finished 消息，完成握手。这个消息是加密的，并且包含了所有前面的握手消息的验证信息，以确保握手过程的完整性和正确性。

如果在任何时候会话恢复失败（例如，服务器没有找到匹配的会话 ID，或者验证失败），则客户端和服务器将回退到完整的握手流程。

## 参考和引用

- [The Transport Layer Security (TLS) Protocol Version 1.2](https://datatracker.ietf.org/doc/html/rfc5246)
