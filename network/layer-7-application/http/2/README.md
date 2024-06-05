## HTTP/2 相对于 HTTP/1.1 的主要改进点

- **二进制分帧（Binary Framing）**：HTTP/2 将所有传输信息分割为更小的消息和帧，并采用二进制格式编码，这使得协议解析更加高效。
- **多路复用（Multiplexing）**：在一个 TCP 连接上可以并行交错地发送和接收多个请求和响应，解决了 HTTP/1.1 的队头阻塞问题。
- **头部压缩（Header Compression）**：使用 HPACK 算法压缩头部，减少传输数据量，尤其对传输大量小型请求时效果显著。
- **服务器推送（Server Push）**：服务器可以主动向客户端推送资源，而无需等待客户端的请求，从而减少延迟。
- **请求优先级（Stream Prioritization）**：客户端和服务器可以协商流的优先级，使得服务器优先处理重要的请求，优化资源利用。
- **流量控制（Flow Control）**：HTTP/2 连接双方都可以实现流量控制，避免发送方发送过量数据导致接收方缓冲区溢出。

![Figure 4.3 HTTP/2 streams are similar to HTTP/1 connections](https://drek4537l1klr.cloudfront.net/pollard/Figures/fig7_1_alt.jpg)

## 创建 HTTP/2 连接的方法

1. **使用 HTTPS 协商（Use HTTPS negotiation）：** 这是最常见的方法，游览器和服务器在 TLS 握手过程中通过 ALPN (Application-Layer Protocol Negotiation) 扩展协商使用 HTTP/2 协议。这种方法的优点是安全，因为所有的通信都是加密的。

2. **使用 HTTP Upgrade 头部（Use the HTTP Upgrade header）：** 客户端在 HTTP/1.1 请求中发送一个 Upgrade 头部，请求升级到 HTTP/2。如果服务器支持 HTTP/2，它会发送一个 101 Switching Protocols 响应，然后客户端和服务器就可以开始使用 HTTP/2 进行通信。这种方法的缺点是不安全，因为通信内容没有加密。

3. **使用先验知识（Use prior knowledge）：** 在这种方法中，客户端已经知道服务器支持 HTTP/2，所以它直接发送 HTTP/2 的请求。这种方法需要客户端和服务器之间有一些先验的协议或者配置。

4. HTTP Alternative Services：使用 HTTP/1.1 或 HTTP/2 的 Alt-Svc 响应头部，允许服务器告诉客户端可以使用其他的协议或网络位置（主机和端口）来访问资源。服务器在响应中包含一个 ALTSVC 头部，告诉客户端可以使用 HTTP/2 连接到一个指定的主机和端口。然后客户端可以选择使用这个新的连接进行后续的请求。

### Use HTTPS negotiation

#### TLS 1.2

1. 客户端 ClientHello
2. 服务端 ServerHello
   1. ServerCertificate
   2. ServerKeyExchange
   3. CertificateRequest6
   4. ServerHelloDone
3. 客户端 ClientCertificate
   1. ClientKeyExchange
   2. Certificate Verify
   3. ChangeCipherSpec
4. 服务端 Finished
5.

```bash
openssl s_client -crlf -connect www.baidu.com:443 -quiet
curl -vso /dev/null --http2 https://www.baidu.com
curl -vso /dev/null --http2 https://www.baidu.com --no-alpn
nghttp -anv https://www.facebook.com I grep -E "frame <|SETTINGs|window_size_increment"
```

### The HTTP/2 preface message

HTTP/2 preface 是在 HTTP/2 连接建立时发送的一段特定的数据，它的目的是为了确认双方都支持 HTTP/2 协议，并且准备好进行 HTTP/2 通信。

HTTP/2 preface 由两部分组成：

1. **Magic String：** 这是一个固定的 24 字节的字符串 "PRI \* HTTP/2.0\r\n\r\nSM\r\n\r\n"。这个字符串在所有的 HTTP/2 连接中都是一样的，用来帮助服务器识别这是一个 HTTP/2 连接。

2. **SETTINGS Frame：** 这是一个 HTTP/2 帧，类型为 SETTINGS。这个帧包含了客户端的一些配置参数，例如最大并发流数量、窗口大小等。服务器会在收到这个帧后回应一个 SETTINGS 帧，以确认这些参数。

HTTP/2 preface 必须是客户端在新的 HTTP/2 连接中发送的第一个数据，服务器在收到并验证了 preface 后，才会开始处理后续的 HTTP/2 帧。如果服务器没有收到正确的 preface，或者 preface 的格式不正确，服务器会关闭连接。

```http
Frame 12: 223 bytes on wire (1784 bits), 223 bytes captured (1784 bits)
Linux cooked capture v2
Internet Protocol Version 4, Src: 192.168.160.1, Dst: 192.168.160.2
Transmission Control Protocol, Src Port: 43532, Dst Port: 443, Seq: 320, Ack: 1542, Len: 151
Transport Layer Security
HyperText Transfer Protocol 2
    Stream: Magic
        Magic: PRI * HTTP/2.0\r\n\r\nSM\r\n\r\n
HyperText Transfer Protocol 2
    Stream: SETTINGS, Stream ID: 0, Length 18
        Length: 18
        Type: SETTINGS (4)
        Flags: 0x00
        0... .... .... .... .... .... .... .... = Reserved: 0x0
        .000 0000 0000 0000 0000 0000 0000 0000 = Stream Identifier: 0
        Settings - Max concurrent streams : 100
        Settings - Initial Windows size : 33554432
        Settings - Enable PUSH : 0
HyperText Transfer Protocol 2
    Stream: WINDOW_UPDATE, Stream ID: 0, Length 4
        Length: 4
        Type: WINDOW_UPDATE (8)
        Flags: 0x00
        0... .... .... .... .... .... .... .... = Reserved: 0x0
        .000 0000 0000 0000 0000 0000 0000 0000 = Stream Identifier: 0
        0... .... .... .... .... .... .... .... = Reserved: 0x0
        .000 0001 1111 1111 0000 0000 0000 0001 = Window Size Increment: 33488897
        [Connection window size (before): 65535]
        [Connection window size (after): 33554432]
```

## HTTP/2 帧

### [帧的格式](https://datatracker.ietf.org/doc/html/rfc7540#section-4.1)

```bash
    +-----------------------------------------------+
    |                 Length (24)                   |
    +---------------+---------------+---------------+
    |   Type (8)    |   Flags (8)   |
    +-+-------------+---------------+-------------------------------+
    |R|                 Stream Identifier (31)                      |
    +=+=============================================================+
    |                   Frame Payload (0...)                      ...
    +---------------------------------------------------------------+
                          Figure 1: Frame Layout
```

**帧头 (Frame Header)**：帧头是每个 HTTP/2 帧的前 9 个字节，包含以下字段：

- **Length (24 bits)**：表示帧的长度，以无符号 24 位整数表示，不包括帧头本身的 9 个字节。长度字段的最大值为 2^24-1 (16,777,215) 字节。**默认情况下，帧长度不能超过 2^14 (16,384) 字节，除非接收方通过 SETTINGS 帧（SETTINGS_MAX_FRAME_SIZE）明确设置了更大的最大帧大小。**

- **Type (8 bits)**：表示帧的类型，以 8 位无符号整数表示，用于标识帧的功能和用途。HTTP/2 定义了多种帧类型，如 DATA、HEADERS、SETTINGS、PING 等。不同类型的帧具有不同的格式和语义。

- **Flags (8 bits)**：包含特定于帧类型的标志位，以 8 位无符号整数表示，用于提供额外的控制信息。不同帧类型的标志位具有不同的含义，例如，END_STREAM 标志表示这是流的最后一个数据帧，END_HEADERS 标志表示这是 HEADERS 帧或 PUSH_PROMISE 帧序列的最后一个帧。

- **R (1 bit)**：保留位，必须设置为 0。

- **Stream Identifier (31 bits)**：标识帧所属的流，以无符号 31 位整数表示。流 ID 为 0 表示该帧适用于整个连接，而不是特定流。有效的流标识符范围是 1 到 2^31-1。

**帧载荷 (Frame Payload)**

- **Frame Payload (0... bytes)**：帧的实际数据内容，根据帧类型的不同而有所变化。例如，DATA 帧的 Payload 包含要传输的数据，HEADERS 帧的 Payload 包含压缩后的 HTTP 头部信息。

**注意：**

- 帧头的 9 个字节 (Length, Type, Flags, R, Stream Identifier) 是所有帧类型共有的。
- 帧的长度是指 Payload 的长度，不包括帧头本身。
- 不同类型的帧具有不同的 Payload 格式和含义。
- 客户端和服务器必须能够识别并处理所有定义的帧类型。

### [HTTP/2 中的关键帧类型介绍](https://datatracker.ietf.org/doc/html/rfc7540#section-6)

#### DATA 帧

用于传输请求或响应的实际 payload 数据，如 HTML 文件主体内容、图片数据等。DATA 帧受流量控制的约束，确保发送方不会发送过多的数据。

#### HEADERS 帧

用于开启一个新的流，并传输 HTTP 首部元数据（header），如请求方法、路径、状态码等。HEADERS 帧可以分多个帧传输，并使用 HPACK 压缩算法来减少传输的数据量。

#### PRIORITY 帧

PRIORITY 帧（type=0x2）用于指定某个流的优先级，影响服务器处理和发送数据的顺序。PRIORITY 帧可以用于初始设置流的优先级，也可以在传输过程中动态调整优先级。

```bash
    +-+-------------------------------------------------------------+
    |E|                  Stream Dependency (31)                     |
    +-+-------------+-----------------------------------------------+
    |   Weight (8)  |
    +-+-------------+

                     Figure 8: PRIORITY Frame Payload
```

1. PRIORITY 帧用于指定某个[流的优先级](https://datatracker.ietf.org/doc/html/rfc7540#section-5.3)。
2. PRIORITY 帧可以在任何流状态下发送，包括 idle 或 closed 状态。
3. PRIORITY 帧的 payload 包含:
   - 一个标志位(E)，指示是否为独占依赖(exclusive)
   - 31 位流标识符，表示该流依赖的流
   - 8 位整数表示流的权重值
4. PRIORITY 帧定义了流依赖(stream dependency)的概念，低优先级流依赖于高优先级流的流控制。
5. PRIORITY 帧长度不等于 5octets 时，将被视为 FRAME_SIZE_ERROR 错误。
6. 如果 PRIORITY 帧的流标识符为 0x0，接收者必须响应 PROTOCOL_ERROR 错误。
7. PRIORITY 帧始终指定一个流，不能指定整个连接。
8. PRIORITY 帧可以用于"idle"或"closed"状态的流，以重新设置优先级。
9. 一个 PRIORITY 帧可以影响指定流及其依赖流的处理，但不影响该流上的帧传输。

#### RST_STREAM 帧

用于终止一个流，通常在发生错误时使用。RST_STREAM 帧包含一个错误码，用于说明终止流的原因。

#### SETTINGS 帧

SETTINGS 帧（type=0x4）用于在连接建立时或连接过程中协商 HTTP/2 连接级别的参数，如头部表大小、初始流控制窗口大小等。SETTINGS 帧可以由客户端或服务器发送。

```bash
    +-------------------------------+
    |       Identifier (16)         |
    +-------------------------------+-------------------------------+
    |                        Value (32)                             |
    +---------------------------------------------------------------+

                         Figure 10: Setting Format
```

1. SETTINGS 帧用于传递影响端点通信方式的配置参数，例如对对等方行为的约束和偏好。
2. SETTINGS 帧的参数不是协商的，而是描述发送方自身的特征，由接收方使用。
3. 两端点可以为同一参数设置不同值。
4. SETTINGS 帧必须在连接建立时由双方发送，并可在连接生命周期内的任何时候发送。
5. SETTINGS 帧定义了 ACK 标志，接收方在应用了新参数后必须立即用 ACK=1 回复一个 SETTINGS 帧。
6. SETTINGS 帧的流标识符必须为 0，否则将被视为 PROTOCOL_ERROR 错误。
7. SETTINGS 帧有效载荷由一个或多个参数构成，每个参数（Identifier）包括 16 位标识符和 32 位值。
8. RFC 定义了以下参数：
   1. `SETTINGS_HEADER_TABLE_SIZE`：定义 HTTP/2 头部压缩（HPACK）使用的最大头部表大小。
   2. `SETTINGS_ENABLE_PUSH`：定义服务器是否可以向客户端推送资源。
   3. `SETTINGS_MAX_CONCURRENT_STREAMS`：定义一个端点可能同时打开的最大并发流数量。
   4. `SETTINGS_INITIAL_WINDOW_SIZE`：定义流控制窗口的初始大小。
   5. `SETTINGS_MAX_FRAME_SIZE`：定义发送端允许的最大帧大小。
   6. `SETTINGS_MAX_HEADER_LIST_SIZE`：定义发送端允许的最大头部列表大小。
9. 未知参数应被忽略。参数以出现顺序处理，参数值以最新出现值为准。
10. 帧长度不是 6 的倍数时将被视为 FRAME_SIZE_ERROR 错误。

总之,SETTINGS 帧规定了 HTTP/2 连接双方的各种配置参数,是实现流控制、并发控制等功能的基础。

#### PUSH_PROMISE 帧

允许服务器主动向客户端推送资源，在客户端请求之前预先发送。PUSH_PROMISE 帧包含被推送资源的头部信息，客户端可以选择接受或拒绝推送。

#### PING 帧

用于测试连接的存活状态和测量往返时间（RTT）。PING 帧不携带任何应用数据，客户端和服务器都可以发送。

#### GOAWAY 帧

用于通知对方即将关闭连接，并指定最后一个被处理的流的 ID。GOAWAY 帧可以由客户端或服务器发送。

#### WINDOW_UPDATE 帧

WINDOW_UPDATE 帧（type=0x8）用于实现流量控制。

```bash
    +-+-------------------------------------------------------------+
    |R|              Window Size Increment (31)                     |
    +-+-------------------------------------------------------------+

                  Figure 14: WINDOW_UPDATE Payload Format
```

1. 流量控制在流级别和连接级别运行。
2. 流量控制是逐跳的，中间节点不转发 WINDOW_UPDATE 帧。
3. 只有 DATA 帧受流量控制，其他帧必须被处理，除非资源不足。
4. WINDOW_UPDATE 帧的负载表示接收方可以额外接收的字节数。
5. WINDOW_UPDATE 帧可以作用于特定的流或整个连接。
6. 窗口增量为 0 的 WINDOW_UPDATE 帧将被视为错误。
7. 流关闭后，WINDOW_UPDATE 帧仍可能被发送。
8. 接收方必须更新受流控制帧影响的连接级流量控制窗口计数。
9. WINDOW_UPDATE 帧长度不等于 4 字节时，将被视为连接错误。

##### CONTINUATION 帧

用于在 HEADERS 帧或 PUSH_PROMISE 帧之后继续传输头部信息。当一个 HEADERS 或 PUSH_PROMISE 帧无法完整包含所有头部信息时，CONTINUATION 帧会被用来分段传输剩余的头部信息。CONTINUATION 帧必须紧跟在 HEADERS 或 PUSH_PROMISE 帧之后，不能插入其他类型的帧。

**另外，HTTP/2 中还有一些其他的帧类型，如：**

- **ALTSVC 帧**：用于通告可替代的服务。这个帧允许服务器通知客户端存在其他协议或地址可用于访问相同的资源。例如，服务器可以通知客户端它支持 HTTP/3 或者 QUIC 协议，客户端可以选择使用这些新协议来提高性能。ALTSVC 帧可以携带关于替代服务的信息，如协议标识符、主机名、端口号等。

- **ORIGIN 帧**：用于标识服务器的 Origin。这个帧允许服务器声明与当前连接关联的 Origin，这对于实现 HTTP/2 的连接合并（Connection Coalescing）特性非常重要。连接合并允许客户端在多个 HTTP/2 连接之间共享 TCP 连接，从而减少连接建立的开销。ORIGIN 帧可以携带 Origin 的信息，如协议方案、主机名、端口号等。

## HTTP/2 的优化

### HTTP/2 中的 HTTP/1.1 反模式

HTTP/1.1 的优化方法在 HTTP/2 中成为反模式的问题：

1. **HTTP/2 的目标**：HTTP/2 的一个主要目标是解决 HTTP/1.1 中请求的开销问题，尽管 HTTP/2 带来了显著的性能提升，但 HTTP 请求仍然有开销。
2. **并发请求的问题**：如果有太多的同时进行的请求，关键资源会被阻塞，这会降低首屏的渲染时间。
3. **HTTP/2 的成熟度**：HTTP/2 的实现还不够成熟，存在一些 Bug，或者对新协议的使用不够高效。
4. **并发下载数量的提升**：HTTP/2 大幅提升了并发下载数量，但并没有移除下载数量的限制。建议保持同域名的请求不超过 100 个。
5. **文件合并的问题**：如果去掉文件合并会有几百个文件的话，则不要去掉文件合并，但可以利用新的下载数量限制来更合理地打包代码。
6. **HTTP/1.1 优化方法的使用**：在 HTTP/2 下，一些 HTTP/1.1 的优化方法不再必要，但在开发者们还在熟悉新协议的时候，移除这些优化方法还太早。
7. **HTTP/2 不是银弹**：虽然大多数网站的性能有所提升，但也有一部分网站的性能没有提升。解释任何预期行为都需要仔细的测试和对协议的认知。

### HTTP/2 下仍然适用的网页性能优化技术

1. **最小化传输数据量**：这通常涉及到压缩数据、优化图片和视频、减少不必要的请求等。
2. **使用缓存防止重复发送数据**：通过合理使用 HTTP 缓存，可以避免重复请求和发送相同的数据。
3. **Service Workers 可以进一步减少网络负载**：Service Workers 可以拦截网络请求，提供缓存的响应，或者在后台进行数据同步，从而减少网络负载。
4. **不发送你不需要的东西**：这涉及到删除不必要的代码、减少 cookie 的大小、避免发送不必要的头信息等。
5. **HTTP 资源提示**：这包括 DNS Prefetch、Preconnect、Prefetch、Preload、Prerender 等，可以帮助浏览器预先进行一些操作，以提高页面的加载速度。
6. **减少最后一英里的延迟**：这涉及到使用 CDN、优化 TCP 设置、使用 HTTP/2 等。
7. **优化 HTTPS**：这涉及到选择合适的加密算法、优化 TLS 握手、使用 HTTP/2 等。
8. **非 HTTP 相关的 Web 性能技术**：这涉及到优化 JavaScript、CSS 和 HTML，使用 WebAssembly，优化 DOM 操作等。

## Stream

### [Stream States](https://datatracker.ietf.org/doc/html/rfc7540#section-5.1)

![Figure 7.2 HTTP/2 stream state diagram](https://drek4537l1klr.cloudfront.net/pollard/Figures/fig7_2_alt.jpg)

### [Flow Control](https://datatracker.ietf.org/doc/html/rfc7540#section-5.2)

HTTP/2 的流量控制（Flow Control）用于防止多路复用的流在 TCP 连接上产生竞争，从而导致流被阻塞。流量控制确保同一连接上的流不会相互干扰。流量控制既用于单个流，也用于整个连接。

1.  **连接特定性**：流量控制仅适用于单个 HTTP/2 连接的端点之间，而不是整个端到端路径。
2.  **基于 WINDOW_UPDATE 帧**：接收方通过发送 WINDOW_UPDATE 帧告知发送方其准备接收的数据量。这是一种基于信用的流量控制机制。
3.  **接收方主导**：流量控制的方向是由接收方控制的。接收方可以为每个流和整个连接设置任意窗口大小。发送方必须遵守接收方设置的流量控制限制。客户端、服务器和中间代理都可以独立地通告自己的流量控制窗口，并在发送数据时遵守对方设置的限制。
4.  **初始窗口大小**：新流和整个连接的流量控制窗口初始值均为 65,535 字节。
5.  **仅 DATA 帧受限**：只有 DATA 帧受流量控制限制。其他类型的帧（如 HEADERS、SETTINGS、PING 等）不占用流量控制窗口，以确保重要的控制帧不会被阻塞。
6.  **不可禁用**：HTTP/2 流量控制始终启用，无法禁用。
7.  **算法灵活性**：HTTP/2 仅定义了 WINDOW_UPDATE 帧的格式和语义，并未规定接收方何时发送该帧或发送何值，也未指定发送方如何发送数据包。这使得实现可以灵活选择适合其需求的流量控制算法。

实现还需要负责管理如何根据优先级发送请求和响应，如何避免队头阻塞，以及如何创建新流。这些算法的选择可能会与流量控制算法相互影响。

### [Stream Priority](https://datatracker.ietf.org/doc/html/rfc7540#section-5.3)

### [Error Handling](https://datatracker.ietf.org/doc/html/rfc7540#section-5.4)

## HTTP Message Exchanges

## 参考和引用

- [HTTP/2 in Action](https://github.com/tunetheweb/http2-in-action)
- [Hypertext Transfer Protocol Version 2 (HTTP/2)](https://datatracker.ietf.org/doc/html/rfc7540)
- https://www.netcraft.com/blog/january-2024-web-server-survey/
- https://github.com/nghttp2/nghttp2
- https://httparchive.org/reports/state-of-the-web
- https://www.webpagetest.org/
- https://w3techs.com/technologies/details/ce-http2
- https://caniuse.com/
- https://letsencrypt.org/stats/
- https://github.com/httpwg/http2-spec/wiki/Implementations
- https://www.ssllabs.com/ssltest/
- https://tools.keycdn.com/http2-test
- https://testssl.sh/
- https://ssl-config.mozilla.org/
- https://httpwg.org/specs/rfc7540.html#BadCipherSuites
- https://netlog-viewer.appspot.com/
- https://tinypng.com/
- https://github.com/summerwind/h2spec
