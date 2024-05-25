## 历史

VXLAN（Virtual Extensible LAN）是一种网络虚拟化技术，它的发展历史可以追溯到 2010 年代初，当时云计算和虚拟化技术正在迅速发展，但是传统的网络技术无法满足新的需求。

在云环境中，通常需要为每个租户创建一个隔离的网络，但是传统的 VLAN 技术只能支持 4096 个网络，这远远无法满足需求。此外，VLAN 也无法跨越不同的网络设备和数据中心。

为了解决这些问题，2012 年，VMware、Cisco、Arista Networks 和 Broadcom 等公司联合提出了 VXLAN 技术。VXLAN 可以支持高达 1600 万个网络，而且可以跨越不同的网络设备和数据中心。

VXLAN 的规范最初是在 IETF 的草案中定义的，后来在 2014 年被正式发布为 RFC 7348。自从发布以来，VXLAN 已经被广泛应用在各种云环境和容器平台中，例如 OpenStack、Kubernetes 等。

在 TCP/IP 模型中，VXLAN（Virtual Extensible LAN）主要属于网络接口层。

VXLAN 是一种网络虚拟化技术，它通过在 IP 数据报（网络层）中封装原始的以太网帧（网络接口层），实现了在跨网络设备、跨数据中心的情况下，能够保持网络的逻辑隔离和统一。因此，它主要涉及到了 TCP/IP 模型的网络接口层。

然而，值得注意的是，由于 VXLAN 使用 UDP 进行封装和传输，因此它也涉及到了传输层。

## 原理

VXLAN（Virtual Extensible LAN）是一种网络虚拟化技术，它主要工作在 OSI 模型的第二层（数据链路层）。它通过将二层以太网帧封装在 UDP（用户数据报协议）数据报中，实现在三层网络上构建虚拟的二层网络。

虽然 VXLAN 使用了 UDP（属于传输层协议）进行封装，但这只是为了在 IP 网络上承载 VXLAN 数据。VXLAN 本身的设计目标是在数据链路层提供虚拟化和扩展能力，因此它仍然被认为是第二层技术。

可以将 VXLAN 的工作原理与 OSI 模型对应起来：

1. **原始数据帧（以太网帧）：** 位于 OSI 模型的第二层（数据链路层）。
2. **VXLAN 封装：** 将原始数据帧封装在 UDP 数据报中，添加 VXLAN 头部信息。这一步发生在传输层（UDP）和网络层（IP）之间。
3. **IP 封装：** 将 VXLAN 数据报封装在 IP 数据报中，添加 IP 头部信息。这一步发生在网络层。
4. **传输：** 封装后的 IP 数据报在网络层传输，到达目的地后进行解封装。

## 格式

```
No.     Time           Source                Destination           Destination Port Protocol Length Info
     18 0.026084       10.1.8.10             10.1.5.10             80               HTTP     188    GET / HTTP/1.1

Frame 18: 188 bytes on wire (1504 bits), 188 bytes captured (1504 bits)
Ethernet II, Src: aa:c1:ab:56:78:04 (aa:c1:ab:56:78:04), Dst: aa:c1:ab:e3:2e:fc (aa:c1:ab:e3:2e:fc)
Internet Protocol Version 4, Src: 172.12.1.11, Dst: 172.12.1.10
User Datagram Protocol, Src Port: 43245, Dst Port: 4789
Virtual eXtensible Local Area Network
Ethernet II, Src: aa:ef:12:3e:76:15 (aa:ef:12:3e:76:15), Dst: 72:dc:26:08:50:a0 (72:dc:26:08:50:a0)
Internet Protocol Version 4, Src: 10.1.8.10, Dst: 10.1.5.10
Transmission Control Protocol, Src Port: 43270, Dst Port: 80, Seq: 1, Ack: 1, Len: 72
Hypertext Transfer Protocol
```

## 使用场景

VXLAN，即虚拟可扩展局域网，是一种网络虚拟化技术。它允许你创建一个跨越物理网络设备的逻辑网络，这个逻辑网络被称为 VXLAN 隧道。VXLAN 隧道可以跨越不同的网络设备，甚至可以跨越不同的数据中心。

VXLAN 的主要优点是它可以大大增加网络的可扩展性。传统的 VLAN 只能支持 4096 个网络，而 VXLAN 可以支持高达 1600 万个网络。这使得 VXLAN 非常适合用于大规模的云环境。

VXLAN 的使用场景包括：

1. 多租户环境：在云环境中，通常需要为每个租户创建一个隔离的网络。使用 VXLAN，你可以为每个租户创建一个或多个 VXLAN 网络，这些网络可以跨越物理设备，但是彼此之间是隔离的。
2. 数据中心互联：如果你有多个数据中心，你可能需要在这些数据中心之间创建一个统一的网络。使用 VXLAN，你可以创建一个跨越所有数据中心的 VXLAN 网络。
3. 容器网络：在 Kubernetes 等容器平台中，每个 Pod 都需要一个独立的网络。使用 VXLAN，你可以为每个 Pod 创建一个 VXLAN 网络，这些网络可以跨越不同的节点，但是彼此之间是隔离的。

请注意，虽然 VXLAN 提供了很多优点，但是它也有一些缺点，例如它会增加网络的复杂性，可能会影响网络性能，需要硬件支持等。因此，在决定是否使用 VXLAN 时，你需要根据你的实际需求和环境进行权衡。

## 参考和引用

- https://datatracker.ietf.org/doc/html/rfc7348
