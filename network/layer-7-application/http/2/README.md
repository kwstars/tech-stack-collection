## HTTP/2 相对于 HTTP/1.1 的主要改进点

- **二进制分帧（Binary Framing）**：HTTP/2 将所有传输信息分割为更小的消息和帧，并采用二进制格式编码，这使得协议解析更加高效。
- **多路复用（Multiplexing）**：在一个 TCP 连接上可以并行交错地发送和接收多个请求和响应，解决了 HTTP/1.1 的队头阻塞问题。
- **头部压缩（Header Compression）**：使用 HPACK 算法压缩头部，减少传输数据量，尤其对传输大量小型请求时效果显著。
- **服务器推送（Server Push）**：服务器可以主动向客户端推送资源，而无需等待客户端的请求，从而减少延迟。
- **请求优先级（Stream Prioritization）**：客户端和服务器可以协商流的优先级，使得服务器优先处理重要的请求，优化资源利用。
- **流量控制（Flow Control）**：HTTP/2 连接双方都可以实现流量控制，避免发送方发送过量数据导致接收方缓冲区溢出。

![Figure 4.3 HTTP/2 streams are similar to HTTP/1 connections](https://drek4537l1klr.cloudfront.net/pollard/Figures/fig7_1_alt.jpg)

## [创建 HTTP/2 连接](https://datatracker.ietf.org/doc/html/rfc7540#section-3)

### 连接方式

1. **使用 HTTP/1.1 升级到 HTTP/2（h2c）**：使用 HTTP Upgrade 头部（Use the HTTP Upgrade header）， 客户端在 HTTP/1.1 请求中发送一个 Upgrade 头部，请求升级到 HTTP/2。如果服务器支持 HTTP/2，它会发送一个 101 Switching Protocols 响应，然后客户端和服务器就可以开始使用 HTTP/2 进行通信。这种方法的缺点是不安全，因为通信内容没有加密。
1. **通过 TLS 建立 HTTP/2 连接（h2）**：使用 HTTPS 协商（Use HTTPS negotiation）这是最常见的方法，游览器和服务器在 TLS 握手过程中通过 ALPN (Application-Layer Protocol Negotiation) 扩展协商使用 HTTP/2 协议。这种方法的优点是安全，因为所有的通信都是加密的。
1. **Prior Knowledge:** 如果客户端事先知道服务器支持 HTTP/2，可以直接发送 HTTP/2 连接前言 (Connection Preface)。

### **连接前言**

**HTTP/2 连接前言 (Connection Preface)**

- **客户端：** 以 24 字节的字符串 "PRI * HTTP/2.0\r\n\r\nSM\r\n\r\n" 开头，后跟一个 SETTINGS 帧。
  1. **Magic String：** 这是一个固定的 24 字节的字符串 "PRI \* HTTP/2.0\r\n\r\nSM\r\n\r\n"。这个字符串在所有的 HTTP/2 连接中都是一样的，用来帮助服务器识别这是一个 HTTP/2 连接。

  2. **SETTINGS Frame：** 这是一个 HTTP/2 帧，类型为 SETTINGS。这个帧包含了客户端的一些配置参数，例如最大并发流数量、窗口大小等。服务器会在收到这个帧后回应一个 SETTINGS 帧，以确认这些参数。
- **服务器：** 仅发送一个 SETTINGS 帧。

**连接前言的作用**

- **确认协议版本：** 客户端和服务器通过发送连接前言来确认对方支持 HTTP/2。
- **初始化设置：** SETTINGS 帧用于设置 HTTP/2 连接的参数。

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

nghttp -anv https://www.facebook.com I grep -E "frame <|SETTINGs|window_size_increment"
```

## HTTP/2 帧

### [帧的格式](https://datatracker.ietf.org/doc/html/rfc7540#section-4.1)

```
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

### [HTTP/2 中的帧类型](https://datatracker.ietf.org/doc/html/rfc7540#section-6)

#### DATA（type=0x0）

DATA 帧 用于传输请求或响应的实际 payload 数据，如 HTML 文件主体内容、图片数据等。

```
    +---------------+
    |Pad Length? (8)|
    +---------------+-----------------------------------------------+
    |                            Data (*)                         ...
    +---------------------------------------------------------------+
    |                           Padding (*)                       ...
    +---------------------------------------------------------------+

                       Figure 6: DATA Frame Payload
```

- **Pad Length (可选)**： 填充长度，仅当 PADDED 标志置位时存在。
- **Data**： 应用数据。
- **Padding (可选)**： 填充字节，用于混淆消息大小，不含应用语义，发送时必须全为零。

**标志**

- **END_STREAM (0x1)**： 表示这是该流的最后一帧。
- **PADDED (0x8)**： 表示存在 Pad Length 和 Padding 字段。

**规则**

- DATA 帧必须与流关联，流标识符为 0 视为 PROTOCOL_ERROR。
- 仅当流处于 "open" 或 "half-closed (remote)" 状态时，才能发送 DATA 帧。
- 整个 DATA 帧（包括填充）受流量控制。
- Padding 长度不得超过帧净荷长度，否则视为 PROTOCOL_ERROR。
- 包含值为 0 的 Pad Length 字段可使帧长度增加 1 字节。

#### HEADERS（type=0x1）

HEADERS 帧用于开启新流并传输 HTTP 头部信息，可以携带可选的填充 (padding) 和优先级 (priority) 信息。

**结构**

```
    +---------------+
    |Pad Length? (8)|
    +-+-------------+-----------------------------------------------+
    |E|                 Stream Dependency? (31)                     |
    +-+-------------+-----------------------------------------------+
    |  Weight? (8)  |
    +-+-------------+-----------------------------------------------+
    |                   Header Block Fragment (*)                 ...
    +---------------------------------------------------------------+
    |                           Padding (*)                       ...
    +---------------------------------------------------------------+

                      Figure 7: HEADERS Frame Payload
```

- **Pad Length (可选)**： 填充长度，仅当 PADDED 标志置位时存在。
- **E**： 优先级独占标志，仅当 PRIORITY 标志置位时存在。
- **Stream Dependency (可选)**： 依赖的流 ID，仅当 PRIORITY 标志置位时存在。
- **Weight (可选)**： 优先级权重，仅当 PRIORITY 标志置位时存在。
- **Header Block Fragment**： 头部块片段，使用 HPACK 压缩。
- **Padding (可选)**： 填充字节，用于混淆消息大小，不含应用语义，发送时必须全为零。

**标志**

- **END_STREAM (0x1)**： 表示这是该流的最后一个头部块。
- **END_HEADERS (0x4)**： 表示当前帧包含完整的头部块，没有后续 CONTINUATION 帧。
- **PADDED (0x8)**： 表示存在 Pad Length 和 Padding 字段。
- **PRIORITY (0x20)**： 表示存在优先级信息 (E, Stream Dependency, Weight)。

**规则**

- HEADERS 帧必须与流关联，流标识符为 0 视为 PROTOCOL_ERROR。
- 如果头部块过大，需要使用 CONTINUATION 帧继续传输。
- 没有 END_HEADERS 标志的 HEADERS 帧必须后跟 CONTINUATION 帧。
- 填充不得超过头部块片段的剩余空间，否则视为 PROTOCOL_ERROR。
- 可以在 HEADERS 帧中包含优先级信息，减少新流创建时的优先级调整开销。

#### PRIORITY（type=0x2）

PRIORITY 帧用于指定某个流的优先级，影响服务器处理和发送数据的顺序。PRIORITY 帧可以用于初始设置流的优先级，也可以在传输过程中动态调整优先级。

```bash
nghttp -nv https://www.163.com | grep -A3 "PRIORITY frame"
```

```
    +-+-------------------------------------------------------------+
    |E|                  Stream Dependency (31)                     |
    +-+-------------+-----------------------------------------------+
    |   Weight (8)  |
    +-+-------------+

                     Figure 8: PRIORITY Frame Payload
```

- **E**： 优先级独占标志，1 表示独占依赖，0 表示非独占依赖。
- **Stream Dependency**： 依赖的流 ID。
- **Weight**： 优先级权重 (1-256)。

**规则**

- PRIORITY 帧用于指定某个[流的优先级](https://datatracker.ietf.org/doc/html/rfc7540#section-5.3)。PRIORITY 帧始终指定一个流，不能指定整个连接。
- PRIORITY 帧定义了流依赖(stream dependency)的概念，低优先级流依赖于高优先级流的流控制。
- PRIORITY 帧长度必须为 5 字节，否则视为 FRAME_SIZE_ERROR。
- 如果 PRIORITY 帧的流标识符为 `0x0`，接收者必须响应 PROTOCOL_ERROR 错误。
- PRIORITY 帧可以用于"idle"或"closed"状态的流，以重新设置优先级。
- 一个 PRIORITY 帧可以影响指定流及其依赖流的处理，但不影响该流上的帧传输。
- PRIORITY 帧不能插入到 HEADERS 帧和 CONTINUATION 帧序列之间。

#### RST_STREAM （type=0x3）

RST_STREAM 帧用于终止一个流，通常在发生错误时使用。RST_STREAM 帧包含一个错误码，用于说明终止流的原因。可以由发送方或接收方发送。

```
    +---------------------------------------------------------------+
    |                        Error Code (32)                        |
    +---------------------------------------------------------------+

                    Figure 9: RST_STREAM Frame Payload
```

- **Error Code**： 32 位无符号整数，表示终止流的原因（[错误码定义](https://datatracker.ietf.org/doc/html/rfc7540#section-7)）。

**规则**

- 终止流，并将其状态转为 "closed"。
- 接收方收到后，不能再发送其他帧（PRIORITY 除外）。
- 发送方发送后，仍需接收和处理对方可能已发送的帧。
- 必须关联到一个流，流标识符为 0x0 时，视为连接错误 (PROTOCOL_ERROR)。
- 不能发送给处于 "idle" 状态的流，否则视为连接错误 (PROTOCOL_ERROR)。
- 长度必须为 4 字节，否则视为连接错误 (FRAME_SIZE_ERROR)。

#### SETTINGS （type=0x4）

SETTINGS 帧用于传输配置参数，影响端点间的通信方式，也用于确认参数的接收。

```
    +-------------------------------+
    |       Identifier (16)         |
    +-------------------------------+-------------------------------+
    |                        Value (32)                             |
    +---------------------------------------------------------------+

                         Figure 10: Setting Format
```

好的，以下是总结 HTTP/2 SETTINGS 帧的描述，语言尽量简短：

**SETTINGS 帧 (type=0x4)**

SETTINGS 帧用于传输配置参数，影响端点间的通信方式，也用于确认参数的接收。

**结构**

```
+-------------------------------+
|       Identifier (16)         |
+-------------------------------+-------------------------------+
|                        Value (32)                             |
+---------------------------------------------------------------+
```

- **Identifier:** 参数标识符。
- **Value:** 参数值。

**标志**

- **ACK (0x1):** 表示这是一个 SETTINGS 确认帧。

**规则**

- 连接建立时双方必须发送，之后可随时发送。
- 每个参数替换现有值，按顺序处理。
- 接收方需立即响应 ACK 帧。
- 仅作用于连接，流标识符必须为 0x0，否则视为 PROTOCOL_ERROR。
- 长度必须为 6 的倍数，否则视为 FRAME_SIZE_ERROR。

**预定义参数**

- SETTINGS_HEADER_TABLE_SIZE (0x1): 定义 HTTP/2 头部压缩（HPACK）使用的最大头部表大小。
- SETTINGS_ENABLE_PUSH (0x2): 定义服务器是否可以向客户端推送资源。
- SETTINGS_MAX_CONCURRENT_STREAMS (0x3): 定义一个端点可能同时打开的最大并发流数量。
- SETTINGS_INITIAL_WINDOW_SIZE (0x4): 流级别的初始流量控制窗口大小。
- SETTINGS_MAX_FRAME_SIZE (0x5): 定义发送端允许的最大帧大小。
- SETTINGS_MAX_HEADER_LIST_SIZE (0x6): 定义发送端允许的最大头部列表大小。

**Settings Synchronization**

SETTINGS 帧的接收方必须尽快应用更新后的参数，并立即发送带有 ACK 标志的 SETTINGS 帧进行确认。如果发送方在合理时间内未收到确认，可以发出 SETTINGS_TIMEOUT 连接错误。

#### PUSH_PROMISE（type=0x5）

PUSH_PROMISE 帧用于通知对端将要发起的流 (stream)。它包含将要创建的流的 ID 和提供额外上下文的头部信息。

```
    +---------------+
    |Pad Length? (8)|
    +-+-------------+-----------------------------------------------+
    |R|                  Promised Stream ID (31)                    |
    +-+-----------------------------+-------------------------------+
    |                   Header Block Fragment (*)                 ...
    +---------------------------------------------------------------+
    |                           Padding (*)                       ...
    +---------------------------------------------------------------+

                  Figure 11: PUSH_PROMISE Payload Format
```

- **Pad Length (可选)**： 填充长度，仅当 PADDED 标志置位时存在。
- **R**： 保留位。
- **Promised Stream ID**： 预留的流 ID，必须是发送方下一个流的有效选择。
- **Header Block Fragment**： 包含请求头字段的头部块片段。
- **Padding (可选)**： 填充字节。

**标志**

- **END_HEADERS (0x4)**： 表示当前帧包含完整的头部块，没有后续 CONTINUATION 帧。
- **PADDED (0x8)**： 表示存在 Pad Length 和 Padding 字段。

**规则**

- 只能发送在对端发起的 "open" 或 "half-closed (remote)" 状态的流上。
- 流标识符为 0x0 时，视为连接错误 (PROTOCOL_ERROR)。
- 预留的流不需要按顺序使用。
- 若对端 SETTINGS_ENABLE_PUSH 设置为 0，则不能发送 PUSH_PROMISE，视为 PROTOCOL_ERROR。
- 接收方可以通过 RST_STREAM 拒绝被允许推送的流。
- PUSH_PROMISE 会修改连接状态，首部压缩状态，并将被允许推送的流置于"reserved"状态。
- 发送方不能在 "open" 或 "half-closed (remote)" 状态之外的流上发送 PUSH_PROMISE。
- 忽略 PUSH_PROMISE 会导致流状态不确定，视为 PROTOCOL_ERROR。
- 预留非法流 ID 视为 PROTOCOL_ERROR。
- 可包含填充，格式与 DATA 帧相同。

#### PING（type=0x6）

PING 帧用于测试连接的存活状态和测量往返时间（RTT）。PING 帧不携带任何应用数据，客户端和服务器都可以发送。

```
    +---------------------------------------------------------------+
    |                                                               |
    |                      Opaque Data (64)                         |
    |                                                               |
    +---------------------------------------------------------------+

                      Figure 12: PING Payload Format
```

- **Opaque Data**： 8 字节数据，可由发送方任意设置。

**标志**

- **ACK (0x1)**： 表示这是一个 PING 响应帧。

**规则**

- 接收未设置 ACK 标志的 PING 帧时，必须发送设置了 ACK 标志的 PING 响应帧，且 Payload 相同。
- PING 响应帧应具有比其他帧更高的优先级。
- PING 帧不与任何流关联，流标识符必须为 0x0，否则视为连接错误 (PROTOCOL_ERROR)。
- PING 帧长度必须为 8 字节，否则视为连接错误 (FRAME_SIZE_ERROR)。

#### GOAWAY（type=0x7）

GOAWAY 帧用于关闭连接或通知严重错误情况，并指定最后一个被处理的流的 ID。GOAWAY 帧可以由客户端或服务器发送。

```
    +-+-------------------------------------------------------------+
    |R|                  Last-Stream-ID (31)                        |
    +-+-------------------------------------------------------------+
    |                      Error Code (32)                          |
    +---------------------------------------------------------------+
    |                  Additional Debug Data (*)                    |
    +---------------------------------------------------------------+

                     Figure 13: GOAWAY Payload Format
```

- **Last-Stream-ID:** 发送方可能已处理或将处理的最后一个对端发起流的标识符。
- **Error Code:** 关闭连接的原因。
- **Additional Debug Data (可选):** 诊断用途的数据。

**规则**

- 仅作用于连接，流标识符必须为 0x0，否则视为 PROTOCOL_ERROR。
- Last-Stream-ID 指示可能已处理的最高编号流，0 表示未处理任何流。
- 接收方收到 GOAWAY 帧后不能打开新流。
- 低于等于 Last-Stream-ID 的流仍可能成功完成。
- 关闭连接前应发送 GOAWAY 帧，以便对端了解流处理情况。
- 可发送多个 GOAWAY 帧，但 Last-Stream-ID 不能增加。
- 发送 GOAWAY 后，可丢弃 Last-Stream-ID 之上的新流，但仍需处理影响连接状态的帧。
- Debug Data 仅用于诊断，可能包含敏感数据，需谨慎处理。

#### WINDOW_UPDATE （type=0x8）

WINDOW_UPDATE 帧用于实现流量控制，调整流或连接的流量控制窗口大小。

```
    +-+-------------------------------------------------------------+
    |R|              Window Size Increment (31)                     |
    +-+-------------------------------------------------------------+

                  Figure 14: WINDOW_UPDATE Payload Format
```

- **Window Size Increment:** 接收方准备额外接收的字节数 (1 ~ 2^31-1)。

**规则**

- 可作用于特定流 (Stream ID > 0) 或整个连接 (Stream ID = 0)。
- 流量控制窗口增量为 0 时，若作用于特定流，则视为 PROTOCOL_ERROR 错误。
- 发送方或接收方都可以发送。
- 接收方收到后，按增量值增加对应流或连接的流量控制窗口大小。
- 流量控制窗口最大为 2^31-1 字节，超出则发送方/接收方发送 FLOW_CONTROL_ERROR 错误并终止流/连接。

**流量控制窗口 (Flow-Control Window)**

- 每个发送方在每个流和整个连接上都维护一个流量控制窗口。
- 窗口大小表示发送方允许发送的字节数，反映接收方的缓冲能力。
- 发送方不能发送超过任一窗口大小的帧，但可以发送长度为 0 的 END_STREAM 帧。
- 帧头 (9 字节) 不计入流量控制。
- 发送帧后，发送方减少对应窗口大小。
- 接收方消费数据后，发送 WINDOW_UPDATE 帧增加窗口大小。
- 初始窗口大小为 65535 字节，可通过 SETTINGS_INITIAL_WINDOW_SIZE 调整。
- SETTINGS 帧可修改活动流的窗口大小，可能导致窗口变为负值，此时发送方须等待 WINDOW_UPDATE 帧。
- 接收方可发送 SETTINGS 帧减小窗口大小，但必须准备好接收超出窗口的数据。

**要点**

- WINDOW_UPDATE 用于动态调整流量控制窗口大小。
- 流量控制确保发送方不会发送超出接收方处理能力的数据。
- 窗口大小是发送方和接收方之间的一种协商机制。

#### CONTINUATION（type=0x9）

CONTINUATION 帧用于继续传输头部块片段 (Header Block Fragment)。

```
    +---------------------------------------------------------------+
    |                   Header Block Fragment (*)                 ...
    +---------------------------------------------------------------+

                   Figure 15: CONTINUATION Frame Payload
```

- **Header Block Fragment:** 头部块片段，使用 HPACK 压缩。

**标志**

- **END_HEADERS (0x4):** 表示这是头部块的最后一帧。

**规则**

- 必须与流关联，流标识符为 0x0 视为 PROTOCOL_ERROR。
- 必须跟随在未设置 END_HEADERS 标志的 HEADERS、PUSH_PROMISE 或 CONTINUATION 帧之后，否则视为 PROTOCOL_ERROR。
- 如果未设置 END_HEADERS 标志，则必须后跟另一个 CONTINUATION 帧。
- 改变连接状态，与头部压缩相关。

**另外，HTTP/2 中还有一些其他的帧类型，如：**

- **ALTSVC 帧**：用于通告可替代的服务。这个帧允许服务器通知客户端存在其他协议或地址可用于访问相同的资源。例如，服务器可以通知客户端它支持 HTTP/3 或者 QUIC 协议，客户端可以选择使用这些新协议来提高性能。ALTSVC 帧可以携带关于替代服务的信息，如协议标识符、主机名、端口号等。

- **ORIGIN 帧**：用于标识服务器的 Origin。这个帧允许服务器声明与当前连接关联的 Origin，这对于实现 HTTP/2 的连接合并（Connection Coalescing）特性非常重要。连接合并允许客户端在多个 HTTP/2 连接之间共享 TCP 连接，从而减少连接建立的开销。ORIGIN 帧可以携带 Origin 的信息，如协议方案、主机名、端口号等。

## Stream

### [Stream States](https://datatracker.ietf.org/doc/html/rfc7540#section-5.1)

![Figure 7.2 HTTP/2 stream state diagram](https://drek4537l1klr.cloudfront.net/pollard/Figures/fig7_2_alt.jpg)

### [Flow Control](https://datatracker.ietf.org/doc/html/rfc7540#section-5.2)

HTTP/2 流量控制通过 WINDOW_UPDATE 帧管理发送方可发送的数据量，防止接收方缓冲区溢出。流量控制在**连接级别**和**流级别**同时生效。

**核心特点**

- **逐跳控制**：仅在相邻节点间生效，中间节点不转发 WINDOW_UPDATE 帧。
- **基于信用**：接收方通过 WINDOW_UPDATE 帧告知发送方可发送的字节数。
- **接收方主导**：接收方设置窗口大小，发送方必须遵守。
- **初始窗口 65535 字节**：可通过 SETTINGS_INITIAL_WINDOW_SIZE 修改。
- **仅 DATA 帧受限**：其他帧类型不占用流量控制窗口。
- **不可禁用**。
- **算法灵活**：HTTP/2 只定义帧格式和语义，具体算法由实现决定。

**适用场景**

- **保护资源受限端点**：如代理服务器需在多连接间共享内存，或上下游连接速度不匹配。
- **防止接收方过载**：接收方无法及时处理数据时，通过流量控制限制发送方的发送速率。

**最佳实践**

- **充足资源时禁用**：可设置最大窗口大小 (2^31-1)，并在收到数据时立即发送 WINDOW_UPDATE 帧。
- **资源受限时启用**：控制对端内存消耗，但可能导致网络资源利用不佳。
- **及时读取 TCP 缓冲区**：避免死锁，尤其在使用流量控制时。

**实现考量**

- 实现需考虑优先级、队头阻塞、新流创建等因素，这些都会与流量控制算法相互影响。
- 具体算法选择取决于实现需求。

### [Stream Priority](https://datatracker.ietf.org/doc/html/rfc7540#section-5.3)

HTTP/2 通过流依赖和权重来表达优先级，用于指导端点在资源有限时如何分配资源和调度传输。

**设置优先级**

- 新建流：在 HEADERS 帧中包含优先级信息。
- 现有流：使用 PRIORITY 帧修改优先级。

**优先级表示**

- Stream Dependency (流依赖):

  流可以依赖于另一个流，

  表示优先处理被依赖的流。

  - Exclusive Dependency: 新流成为父流的唯一依赖，原有依赖转为新流的依赖。

- **Weight (权重):** 同一父流下的子流分配权重 (1-256)，权重越高，分配的资源越多。

**优先级规则**

- 优先级仅为建议，不保证处理或传输顺序。
- 可省略优先级信息，使用默认优先级。
- 依赖流仅在所有祖先流关闭或无法进展时才分配资源。
- 流不能依赖自己，否则视为 PROTOCOL_ERROR。
- 默认情况下，所有流非独占依赖于 0 号流，推送流依赖于关联流，默认权重为 16。

**优先级管理**

- 流关闭时，其依赖可转移到其父流。
- 关闭流导致优先级信息丢失，资源在同级流间重新分配。
- 应保留已关闭流的优先级状态一段时间，避免新流被分配错误优先级。
- 空闲流可被赋予优先级或成为父流。
- 可限制保留的优先级状态数量，高负载时可丢弃部分状态。

## HTTP Message Exchanges

### [HTTP Request/Response Exchange](https://datatracker.ietf.org/doc/html/rfc7540#section-8.1)

HTTP/2 使用流 (stream) 来发送请求和接收响应。

**HTTP 消息结构**

1. 仅响应：0个或多个 HEADERS 帧（后跟 CONTINUATION 帧）包含 1xx 响应头。
2. 1个 HEADERS 帧（后跟 CONTINUATION 帧）包含消息头。
3. 0个或多个 DATA 帧包含消息体。
4. 可选的1个 HEADERS 帧（后跟 CONTINUATION 帧）包含尾部 (trailer-part)。

最后一帧带有 END_STREAM 标志。

### [Server Push](https://datatracker.ietf.org/doc/html/rfc7540#section-8.2)

HTTP/2 允许服务器在客户端请求之前主动推送资源，从而减少延迟。

**工作流程**

1. 服务器在某个流上发送 PUSH_PROMISE 帧，通知客户端将要推送的资源。
2. 客户端可以选择接受或拒绝推送。
3. 如果接受，服务器在新的流上发送推送的响应。

**PUSH_PROMISE 帧**

- 包含 Promised Stream ID（预留的流 ID）和请求头信息。
- 必须在客户端发起的流上发送。
- 必须包含安全且可缓存的方法 (safe and cacheable method)。

**推送的响应**

- 必须是针对客户端显式请求的。
- 在服务器发起的流上发送。
- 客户端可以拒绝接收，发送 RST_STREAM 帧。

**其他**

- 客户端可通过 SETTINGS_MAX_CONCURRENT_STREAMS 限制推送的并发数。
- 客户端必须验证服务器的权威性或代理的配置。
- 服务器推送不能用于非幂等操作。
- 服务器推送的响应不能被缓存。

## HTTP/2 CONNECT

HTTP/2 CONNECT 方法主要用于以下场景：

1. **通过 HTTP 代理建立 TLS 隧道 (HTTPS 代理)**：
   - 客户端通过 CONNECT 方法向代理服务器请求建立到目标服务器的 TCP 隧道。
   - 代理服务器与目标服务器建立 TLS 连接，并将后续的通信数据在隧道中透明传输。
   - 客户端和目标服务器之间建立安全的 HTTPS 连接，实现加密通信。
2. **访问不支持 HTTP/2 的服务器**：
   - 某些旧版服务器可能不支持 HTTP/2，但支持 HTTP/1.1。
   - 客户端可以通过 CONNECT 方法与代理服务器建立 HTTP/2 连接，然后通过代理服务器使用 HTTP/1.1 协议与目标服务器通信。
3. **实现自定义协议**：
   - 开发者可以利用 CONNECT 方法在 HTTP/2 连接上实现自定义的应用层协议。
   - 客户端和服务器可以通过 DATA 帧在 CONNECT 流上传输自定义协议的数据。
4. **WebSocket 隧道**：
   - 在不支持 WebSocket 协议的网络环境中，可以使用 CONNECT 方法通过 HTTP/2 代理建立 WebSocket 隧道。

**需要注意的是：**

- HTTP/2 CONNECT 方法仅适用于单个流 (stream)，无法实现 HTTP/1.1 CONNECT 方法那样的多路复用。
- 在 CONNECT 方法建立的隧道中，只能传输 DATA 帧和流管理帧 (RST_STREAM, WINDOW_UPDATE, PRIORITY)，其他类型的帧会被视为错误。
- 由于 HTTP/2 在实际应用中通常与 TLS 结合使用 (h2)，因此通过 CONNECT 方法建立的隧道通常也是加密的。

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

## 参考和引用

- [HTTP/2 in Action](https://github.com/tunetheweb/http2-in-action)
- [Hypertext Transfer Protocol Version 2 (HTTP/2)](https://datatracker.ietf.org/doc/html/rfc7540)
- [HPACK: Header Compression for HTTP/2](https://datatracker.ietf.org/doc/html/rfc7541)
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
