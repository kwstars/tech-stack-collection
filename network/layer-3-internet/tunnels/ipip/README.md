## 历史

IPIP（IP in IP）是一种网络隧道协议，它允许在 IP 数据报中封装另一个 IP 数据报。这种技术最初在 RFC 1853 中描述，该 RFC 于 1995 年发布。

IPIP 的主要用途是在不同的网络之间创建隧道。这种隧道可以用于连接在地理上分散的网络，或者用于在不同的 IP 网络之间进行路由。

IPIP 的一个重要特性是它的简单性。它只是简单地在原始 IP 数据报前面添加了一个新的 IP 头部。这使得 IPIP 非常容易实现，而且对网络性能的影响很小。

然而，IPIP 也有一些缺点。最重要的是，它不提供任何形式的加密或身份验证。这意味着 IPIP 隧道本身并不安全，因此通常需要与其他安全协议（如 IPSec）一起使用。

总的来说，尽管 IPIP 是一个相对较旧的技术，但由于其简单性和效率，它在今天的网络环境中仍然被广泛使用。

## 格式

```
No.     Time           Source                Destination           Destination Port Protocol Length Info
     10 0.000294       10.1.8.10             10.1.5.10             53946            HTTP     209    HTTP/1.1 200 OK  (text/html)

Frame 10: 209 bytes on wire (1672 bits), 209 bytes captured (1672 bits)
Ethernet II, Src: aa:c1:ab:20:78:86 (aa:c1:ab:20:78:86), Dst: aa:c1:ab:e1:0e:cb (aa:c1:ab:e1:0e:cb)
Internet Protocol Version 4, Src: 172.12.1.11, Dst: 172.12.1.10
Internet Protocol Version 4, Src: 10.1.8.10, Dst: 10.1.5.10
Transmission Control Protocol, Src Port: 80, Dst Port: 53946, Seq: 238, Ack: 73, Len: 123
[2 Reassembled TCP Segments (360 bytes): #8(237), #10(123)]
Hypertext Transfer Protocol
Line-based text data: text/html (1 lines)
```
