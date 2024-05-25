## 历史

GRE（Generic Routing Encapsulation）是一种网络协议，用于在网络上封装任何网络层协议。它最初由 Cisco Systems 开发，并在 RFC 1701 中进行了描述。GRE 最初的目标是在 IP 网络上提供点对点的封装，以便在不同的协议之间进行路由。

GRE 的主要优点是它可以封装几乎任何类型的网络协议，包括 IP、IPv6、NetWare IPX、AppleTalk、DECnet 等。这使得 GRE 成为在异构网络环境中进行路由的理想选择。

GRE 在 1994 年首次出现在 Cisco 的 IOS 11.1 中。随后，许多其他网络设备制造商也开始支持 GRE，使得它成为一种广泛使用的网络封装协议。

尽管 GRE 是一个相对简单的协议，但它也有一些缺点。例如，GRE 本身不提供任何形式的安全性或身份验证。因此，它通常需要与其他协议（如 IPSec）一起使用，以提供安全的网络连接。

总的来说，GRE 是一个强大而灵活的网络封装协议，它在过去的几十年中已经证明了自己的价值，并且在今天的网络环境中仍然广泛使用。

## 格式

```
No.     Time           Source                Destination           Destination Port Protocol Length Info
     10 0.000280       10.1.8.10             10.1.5.10             41146            HTTP     213    HTTP/1.1 200 OK  (text/html)

Frame 10: 213 bytes on wire (1704 bits), 213 bytes captured (1704 bits)
Ethernet II, Src: aa:c1:ab:48:38:1e (aa:c1:ab:48:38:1e), Dst: aa:c1:ab:c5:6b:d3 (aa:c1:ab:c5:6b:d3)
Internet Protocol Version 4, Src: 172.12.1.11, Dst: 172.12.1.10
Generic Routing Encapsulation (IP)
Internet Protocol Version 4, Src: 10.1.8.10, Dst: 10.1.5.10
Transmission Control Protocol, Src Port: 80, Dst Port: 41146, Seq: 238, Ack: 73, Len: 123
[2 Reassembled TCP Segments (360 bytes): #8(237), #10(123)]
Hypertext Transfer Protocol
Line-based text data: text/html (1 lines)
```
