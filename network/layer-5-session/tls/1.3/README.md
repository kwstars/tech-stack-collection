## TLS 1.3 主要变化

- 仅支持更安全的加密算法，放弃旧算法。
- 可选 0-RTT 模式，加速连接建立，但牺牲部分安全性。
- 所有密钥交换均提供前向安全，不支持静态 RSA 和 DH。
- ServerHello 后所有握手消息加密，提升隐私性。
- 简化密钥导出函数，更易分析。
- 重构握手过程，更一致，移除不必要的消息。
- 内置椭圆曲线算法，支持 EdDSA 等新签名算法。
- 改进 RSA 填充，移除压缩、DSA 和自定义 DH 组。
- 弃用 TLS 1.2 版本协商机制，提升兼容性。
- 统一会话恢复机制。

对 TLS 1.2 的影响：

- 引入版本降级保护机制。
- 定义 RSASSA-PSS 签名方案。
- 引入 "supported_versions" 扩展用于版本协商。
- 引入 "signature_algorithms_cert" 扩展用于签名算法指示。

此外，文档还澄清了 TLS 早期版本的一些合规要求。

## [TLS 1.3 握手协议概述](https://datatracker.ietf.org/doc/html/rfc8446#section-2)

### Message Flow for Full TLS Handshake

```
       Client                                           Server

Key  ^ ClientHello
Exch | + key_share*
     | + signature_algorithms*
     | + psk_key_exchange_modes*
     v + pre_shared_key*       -------->
                                                  ServerHello  ^ Key
                                                 + key_share*  | Exch
                                            + pre_shared_key*  v
                                        {EncryptedExtensions}  ^  Server
                                        {CertificateRequest*}  v  Params
                                               {Certificate*}  ^
                                         {CertificateVerify*}  | Auth
                                                   {Finished}  v
                               <--------  [Application Data*]
     ^ {Certificate*}
Auth | {CertificateVerify*}
     v {Finished}              -------->
       [Application Data]      <------->  [Application Data]

              +  Indicates noteworthy extensions sent in the
                 previously noted message.

              *  Indicates optional or situation-dependent
                 messages/extensions that are not always sent.

              {} Indicates messages protected using keys
                 derived from a [sender]_handshake_traffic_secret.

              [] Indicates messages protected using keys
                 derived from [sender]_application_traffic_secret_N.

               Figure 1: Message Flow for Full TLS Handshake
```

TLS 握手过程中的标识符具有以下含义：

- **"+"**： 表示在前面提到的消息中发送的重要扩展。这些扩展通常包含对握手过程或安全连接产生影响的附加信息，例如密钥共享、签名算法或预共享密钥模式等。

- **"\*"**： 表示可选或取决于情况的消息/扩展。这些消息或扩展并非在每次握手中都发送，而是根据协商的加密套件、身份验证需求或其他因素来决定是否发送。例如，Certificate 消息在服务器不进行证书认证时可以省略。

- **"{}"**： 表示使用派生自 `[sender]_handshake_traffic_secret` 的密钥保护的消息。握手流量密钥（handshake traffic secret）是在握手过程中生成的一组密钥，用于保护握手消息的机密性和完整性。这些消息在密钥交换完成后发送，因此可以使用握手流量密钥进行加密。

- **"[]"**： 表示使用派生自 `[sender]_application_traffic_secret_N` 的密钥保护的消息。应用流量密钥（application traffic secret）是在握手完成后生成的一组密钥，用于保护应用数据的机密性和完整性。方括号中的 N 表示密钥的世代数，随着会话的进行，密钥可能会更新。

TLS 1.3 完整握手流程总结：

1. **密钥交换阶段 (Key Exchange)**：

   - 客户端发送 ClientHello，包含协议版本、加密套件、密钥交换参数（Diffie-Hellman 或预共享密钥）等。
   - 服务器回复 ServerHello，确认协议版本、加密套件，并发送密钥交换参数。

2. **服务器参数阶段 (Server Parameters)**：

   - 服务器发送 EncryptedExtensions，用于在密钥协商完成后安全地传递对 ClientHello 扩展的响应以及其他不影响密钥协商但需要保密的参数，从而提高通信的安全性、效率和可扩展性。
   - 服务器发送 CertificateRequest（可选），请求客户端提供证书进行身份验证。

3. **身份验证阶段 (Authentication)**：
   - 服务器发送 Certificate（可选），包含数字证书。
   - 服务器发送 CertificateVerify（可选），证明证书所有权。
   - 服务器发送 Finished 消息，完成服务器端的握手。
   - 客户端发送 Certificate（可选），包含数字证书。
   - 客户端发送 CertificateVerify（可选），证明证书所有权。
   - 客户端发送 Finished 消息，完成客户端的握手。

握手完成后，双方使用协商的密钥进行加密通信。

### Message Flow for a Full Handshake with Mismatched Parameters

因为客户端和服务器在初始的 ClientHello 和 ServerHello 消息中未能就某些关键参数达成一致。具体来说，以下情况可能导致参数不匹配：

1. **密钥交换参数不匹配**：客户端提供的 Diffie-Hellman (DHE) 或椭圆曲线 Diffie-Hellman (ECDHE) 密钥共享参数不符合服务器的要求，例如客户端提供的密钥共享组不被服务器支持或服务器认为不安全。
2. **加密套件不匹配**： 客户端提供的加密套件列表中没有服务器支持或愿意使用的套件。
3. **协议版本不匹配**：客户端请求的 TLS 版本不被服务器支持。
4. **其他扩展参数不匹配**：客户端在 ClientHello 中发送的其他扩展（如 ALPN、SNI 等）与服务器的配置或要求不符。

为了解决参数不匹配的问题，TLS 1.3 引入了 HelloRetryRequest 机制。当服务器发现参数不匹配时，会发送 HelloRetryRequest 消息给客户端，告知客户端哪些参数需要修改。客户端收到 HelloRetryRequest 消息后，会重新发送 ClientHello 消息，并根据服务器的要求调整参数。如果经过多次协商仍然无法达成一致，握手过程就会失败。

这种参数不匹配的情况在实际应用中比较常见，尤其是在客户端和服务器的软件版本、配置或安全策略存在差异时。HelloRetryRequest 机制可以有效地解决参数不匹配问题，确保 TLS 1.3 握手过程的顺利进行。

```
        Client                                               Server

        ClientHello
        + key_share             -------->
                                                  HelloRetryRequest
                                <--------               + key_share
        ClientHello
        + key_share             -------->
                                                        ServerHello
                                                        + key_share
                                              {EncryptedExtensions}
                                              {CertificateRequest*}
                                                     {Certificate*}
                                               {CertificateVerify*}
                                                         {Finished}
                                <--------       [Application Data*]
        {Certificate*}
        {CertificateVerify*}
        {Finished}              -------->
        [Application Data]      <------->        [Application Data]

             Figure 2: Message Flow for a Full Handshake with
                           Mismatched Parameters
```

TLS 1.3 参数不匹配的完整握手流程总结：

1. 客户端发送 ClientHello 消息，但包含的 key_share 扩展不满足服务器要求。
2. 服务器回复 HelloRetryRequest 消息，指定期望的 key_share 参数。
3. 客户端重新发送 ClientHello 消息，包含正确的 key_share 参数。
4. 服务器回复 ServerHello 消息，确认协商参数。
5. 服务器发送 EncryptedExtensions、CertificateRequest（可选）、Certificate（可选）、CertificateVerify（可选）、Finished 消息。
6. 客户端发送 Certificate（可选）、CertificateVerify（可选）、Finished 消息。

握手完成后，双方使用协商的密钥进行加密通信。

### Message Flow for Resumption and PSK

TLS 1.3 中的 "Resumption and PSK" 握手流程，它包括两个阶段：初始握手和后续握手。

在初始握手阶段，客户端和服务器进行一次完整的握手，建立新的会话。握手完成后，服务器发送一个 NewSessionTicket 消息给客户端，这个消息包含了会话的信息，客户端可以保存这个信息，用于后续的握手。

在后续握手阶段，客户端发送一个包含 pre_shared_key 扩展的 ClientHello 消息给服务器。这个扩展包含了从 NewSessionTicket 消息中获取的会话票据。服务器收到这个消息后，确认会话票据，然后发送 ServerHello 消息给客户端，完成握手。

这个流程允许客户端和服务器使用预共享密钥 (PSK) 或之前的会话信息来快速建立新的安全连接，而无需进行完整的握手。这可以提高握手的效率，特别是在网络条件不佳的情况下。

```
          Client                                               Server

   Initial Handshake:
          ClientHello
          + key_share               -------->
                                                          ServerHello
                                                          + key_share
                                                {EncryptedExtensions}
                                                {CertificateRequest*}
                                                       {Certificate*}
                                                 {CertificateVerify*}
                                                           {Finished}
                                    <--------     [Application Data*]
          {Certificate*}
          {CertificateVerify*}
          {Finished}                -------->
                                    <--------      [NewSessionTicket]
          [Application Data]        <------->      [Application Data]


   Subsequent Handshake:
          ClientHello
          + key_share*
          + pre_shared_key          -------->
                                                          ServerHello
                                                     + pre_shared_key
                                                         + key_share*
                                                {EncryptedExtensions}
                                                           {Finished}
                                    <--------     [Application Data*]
          {Finished}                -------->
          [Application Data]        <------->      [Application Data]

               Figure 3: Message Flow for Resumption and PSK
```

TLS 1.3 的会话恢复和预共享密钥（PSK）总结：

1. 会话恢复：

   - TLS 1.3 采用 PSK（Pre-Shared Key）实现会话恢复，取代了 TLS 1.2 中的会话 ID 和会话票证机制。
   - 服务器在握手完成后发送 NewSessionTicket 消息给客户端，其中包含 PSK 标识符，用于后续会话恢复。
   - 客户端在后续握手时，通过 ClientHello 消息中的 pre_shared_key 扩展提供 PSK 标识符。
   - 如果服务器接受 PSK，则可以直接使用 PSK 建立会话，无需重新进行密钥交换。

2. 预共享密钥（PSK）：

   - PSK 可以在带外预先配置，也可以通过先前的 TLS 连接建立。
   - PSK 可以与 (EC)DHE 密钥交换结合使用，提供前向保密性。
   - 单独使用 PSK 时，会失去应用数据的正向保密性。
   - 使用带外预配置的 PSK 时，必须保证密钥生成过程有足够的熵，避免低熵密钥带来的安全风险。
   - PSK 认证并非强密码认证，无法抵御观察握手过程的攻击者进行的暴力破解。

3. 握手流程：
   - 初次握手：客户端发送 ClientHello，服务器回复 ServerHello、EncryptedExtensions、(CertificateRequest)、(Certificate)、(CertificateVerify)、Finished，客户端回复 (Certificate)、(CertificateVerify)、Finished，服务器发送 NewSessionTicket。
   - 会话恢复握手：客户端发送 ClientHello (包含 PSK)，服务器回复 ServerHello (包含 PSK)、EncryptedExtensions、Finished，客户端回复 Finished。

### Message Flow for a 0-RTT Handshake

0-RTT 数据是在 TLS 1.3 握手完成前，客户端使用预共享密钥（PSK）加密并发送给服务器的应用数据。

**优点：**

- 减少握手时间，提高连接速度。
- 在网络质量较差的情况下，可以更快地加载页面或应用。

**缺点：**

- 0-RTT 数据没有前向保密性，因为只使用 PSK 加密。
- 0-RTT 数据容易受到重放攻击，攻击者可以重放之前的数据包。
- 0-RTT 数据在应用层可能需要额外的防重放机制。

**适用场景：**

- 适用于对安全性要求不高，但对性能要求较高的场景，例如加载静态资源、更新软件等。
- 不适用于涉及敏感操作的场景，例如金融交易、身份验证等。

```
         Client                                               Server

         ClientHello
         + early_data
         + key_share*
         + psk_key_exchange_modes
         + pre_shared_key
         (Application Data*)     -------->
                                                         ServerHello
                                                    + pre_shared_key
                                                        + key_share*
                                               {EncryptedExtensions}
                                                       + early_data*
                                                          {Finished}
                                 <--------       [Application Data*]
         (EndOfEarlyData)
         {Finished}              -------->
         [Application Data]      <------->        [Application Data]

               +  Indicates noteworthy extensions sent in the
                  previously noted message.

               *  Indicates optional or situation-dependent
                  messages/extensions that are not always sent.

               () Indicates messages protected using keys
                  derived from a client_early_traffic_secret.

               {} Indicates messages protected using keys
                  derived from a [sender]_handshake_traffic_secret.

               [] Indicates messages protected using keys
                  derived from [sender]_application_traffic_secret_N.

               Figure 4: Message Flow for a 0-RTT Handshake
```

## 参考和引用

- [The Transport Layer Security (TLS) Protocol Version 1.3](https://datatracker.ietf.org/doc/html/rfc8446)
- https://blog.cloudflare.com/rfc-8446-aka-tls-1-3
- https://www.a10networks.com/glossary/key-differences-between-tls-1-2-and-tls-1-3/
