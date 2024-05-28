## 简介

BGP (Border Gateway Protocol) 是一种路径向量协议，主要用于在自治系统（AS）之间进行路由信息的交换称。BGP 是互联网的主要路由协议，它允许网络管理员通过设置路由策略来控制路由信息的传播。

AS 分类主要分为公共 ASN 和私有 AS。公共 AS 的范围是 1 到 64511，用于全球范围内的网络自治系统。而私有 AS 的范围是 64512 到 65535，用于内部网络或者特定的私有网络中。

在 BGP 路由和管理方面，对于 eBGP 路由，其管理距离为 20，而对于 iBGP 路由，则为 200。BGP 邻居通常被称为“对等体”，并且必须通过静态分配来配置。这些对等体使用 TCP 端口 179 来接收更新并维持活动状态。

BGP 利用自治系统编号来标识路径，并利用路径向量属性来预防路由环路的发生。在路由更新离开自治系统时，会添加本地自治系统编号，以便其他路由器了解该路径的来源。当 BGP 路由器收到更新时，会检查自治系统编号列表，如果发现自身编号，则会丢弃该更新，以防止环路的产生。

## BGP Databases

BGP 有两个独立的路由协议数据库：

1. **Neighbor Database**：列出所有配置的 BGP 邻居。

2. **BGP Database**：列出所有 BGP 已知网络及其属性。

## BGP Message Types

BGP (Border Gateway Protocol) 有四种类型的报文：

1. **OPEN（建立对等连接）**：在配置 BGP 邻居后，路由器发送 Open 消息以建立与邻居的对等连接。
2. **UPDATE（传输路由信息）**：用于在对等体之间传输路由信息的消息类型。
3. **KEEPALIVE（维持邻居状态）**：BGP 对等体每 60 秒发送一次 Keepalive 消息，以维持活跃的邻居状态。
4. **NOTIFICATION（通知并关闭会话）**：如果发生问题且必须断开 BGP 对等连接，则发送 Notification 消息并关闭会话。

## iBGP and eBGP

BGP (Border Gateway Protocol) 是一种用于在自治系统（AS）之间交换路由和可达性信息的协议。BGP 有两种主要的类型：iBGP 和 eBGP。

在下图中，R3 和 R4 是 eBGP 对等体。 R1 和 R3 以及 iBGP 对等体。

![img](https://forum.huawei.com/enterprise/api/file/v1/small/thread/667296222030991360.jpg?appid=esc_en)

### iBGP

1. 它在同一个自治系统内部的路由器之间使用。
2. 它不会改变路由信息的属性，即它会保留从其他自治系统接收到的原始路由信息。
3. 这使得自治系统内部的路由器可以看到互联网的完整路由表。
4. 然而，iBGP 有一个问题，那就是路由信息在自治系统内部不会被默认传播。
5. 为了解决这个问题，我们通常使用路由反射（Route Reflection）或者全网互联（Full Mesh）。

#### BGP Split Horizon

BGP Split Horizon 是 BGP（边界网关协议）中的一个规则，主要用于防止路由循环。这个规则在 iBGP（内部边界网关协议）中特别重要。

在 BGP Split Horizon 规则中，一个 BGP speaker 不会将从一个 iBGP 邻居接收到的路由信息发送给其他 iBGP 邻居。这是因为在 iBGP 中，所有的 BGP speaker 都假定彼此直接相连，因此如果一个 BGP speaker 将从一个 iBGP 邻居接收到的路由信息发送给其他 iBGP 邻居，就可能导致路由循环。

![img](https://forum.huawei.com/enterprise/api/file/v1/small/thread/667919174195875840.png?appid=esc_en)

例如，假设有三个 BGP speaker A、B 和 C，它们都是 iBGP 邻居。A 从 B 接收到一个路由信息，然后将这个路由信息发送给 C。C 可能会认为这个路由信息是从 A 直接接收到的，因此将这个路由信息再次发送给 B，从而形成一个路由循环。

BGP Split Horizon 规则通过阻止 BGP speaker 将从一个 iBGP 邻居接收到的路由信息发送给其他 iBGP 邻居，有效地防止了这种路由循环的发生。但是它也导致了一个问题，那就是在大型网络中，每个路由器都需要与其他所有的路由器建立 iBGP 会话，这会导致 iBGP 会话的数量呈指数级增长，从而增加了网络的复杂性。

为了解决这个问题，我们通常会使用路由反射器或者联邦系统来减少 iBGP 会话的数量。

- 路由反射器可以将从一个 iBGP 邻居学习到的路由信息反射给其他的 iBGP 邻居，从而打破了 Split Horizon 规则，
- 联邦系统则是将一个大型的自治系统划分为多个小型的自治系统，每个小型的自治系统内部使用 iBGP，而小型的自治系统之间使用 eBGP。

#### Route Reflection

Route Reflection 是 BGP（边界网关协议）中的一个概念，用于解决 iBGP 全网互联的问题。在传统的 iBGP 网络中，每个 iBGP speaker 都需要与网络中的其他所有 iBGP speaker 建立连接，这在大型网络中会导致连接数量急剧增加，管理复杂。

Route Reflection 是为了解决这个问题而提出的。在 Route Reflection 中，引入了一个新的角色：Route Reflector（路由反射器）。Route Reflector 可以将从一个 iBGP 邻居接收到的路由信息反射（即重新发送）给其他 iBGP 邻居，而无需与网络中的每个 iBGP speaker 都建立连接。

这样，网络中的 iBGP speaker 只需要与 Route Reflector 建立连接，而不需要与所有其他 iBGP speaker 都建立连接，大大简化了网络管理。

在 BGP Route Reflector 架构中，主要有两种角色：

1. Route Reflector (RR)：路由反射器，负责接收并反射路由信息。它可以从一个 iBGP 邻居接收到的路由信息反射（即重新发送）给其他 iBGP 邻居。

2. Client：客户端，与 Route Reflector 建立 BGP 会话的 iBGP 邻居。客户端将其路由信息发送给 Route Reflector，然后由 Route Reflector 反射给其他客户端或非客户端。

![img](https://forum.huawei.com/enterprise/api/file/v1/small/thread/667919552211718144.png?appid=esc_en)

除了这两种角色外，还有一种是非客户端 iBGP 邻居，它们与 Route Reflector 建立 BGP 会话，但 Route Reflector 不会将从其他非客户端 iBGP 邻居接收到的路由信息反射给它们。

BGP Route Reflector (RR)的规则如下：

1. 客户端路由反射至所有非源客户端和非客户端。
2. 非客户端路由反射至所有客户端。
3. eBGP 路由发送至所有客户端和非客户端。

![img](https://forum.huawei.com/enterprise/api/file/v1/small/thread/667919552438210560.png?appid=esc_en)

![img](https://forum.huawei.com/enterprise/api/file/v1/small/thread/667919552652120064.png?appid=esc_en)

### eBGP

1. 它在不同自治系统之间的路由器使用。
2. 它会改变路由信息的属性，例如 AS_PATH 和 NEXT_HOP。
3. 这使得每个自治系统可以根据自己的策略来选择最佳的路由。
4. eBGP 通常用于连接互联网上的不同网络，例如 ISP 之间的连接。

## Resetting BGP Sessions

背景：

- **问题描述**：运行 BGP 的互联网路由器拥有庞大的路由表。当应用过滤器（如路由映射）时，BGP 属性可能发生变化。这些变化可能影响已经存在于 BGP 路由表中的许多路由。
- **挑战**：BGP 网络列表通常很长，应用路由映射或前缀列表后，路由器需要检查每个可能的路由和属性组合。如果拉回邻居的路由会导致再次收敛，从而引发更多问题。

解决方案：

- **BGP 稳定性**：BGP 为了保持稳定，只在过滤器应用后才会对路由属性和网络进行更改。所有现有路由保持不变。
- **管理员决定**：如果网络管理员决定需要对所有路由应用过滤器，则必须重置 BGP 实例，使整个 BGP 表通过过滤器。

会话重置的方法：

1. **硬重置 (Hard Reset)**：强制重置 BGP 会话，重新计算所有路由。非常消耗内存。
2. **软重置 (Soft Reset)**：部分重置 BGP 会话，重新计算需要更新的路由。仍然消耗大量内存。
3. **路由刷新 (Route Refresh)**：为解决高内存问题而开发，同时仍然强制重置。相对不那么消耗内存。

## BGP Path Selection

BGP（边界网关协议）的路径选择与大多数其他路由协议不同，它不仅仅关注到达给定目标的最快路径。相反，BGP 为每条路径分配一长串属性，每个属性都可以进行管理调整，以实现对路由选择的极其细粒度控制。

BGP 属性分为几类：

1. **强制性的众所周知的属性（Mandatory Well Known Attributes）**：这些属性是每个路由更新和决策的必要部分。包括：

   - **Origin**：表示路由起源的类型，可能的值有 i（内部）、e（外部）和 ?（未知）。
   - **AS_Path**：路由器将 AS 添加到每个自治系统。
   - **Next_Hop**：下一跳路由器的 IP 地址。

2. **自由决定的众所周知的属性（Discretionary Well Known Attributes）**：这些属性不是必须的，但如果存在，所有 BGP 实现都应理解。包括：

   - **Local-Preference**：用于一致的路由策略。
   - **Atomic Aggregate**：通知邻居路由器已经聚合了路由。

3. **可选属性（Optional Attributes）**：这些属性可以存在也可以不存在，包括：

   - **Transitive**：如果一个 BGP 会话接收到一个具有传递属性的更新，它会将该更新传递给其他 BGP 会话。
   - **Nontransitive**：如果一个 BGP 会话接收到一个具有非传递属性的更新，它不会将该更新传递给其他 BGP 会话。
   - **Multi-exit discriminator or MED**：用于指示到达 AS 的首选出口。

**路径属性（Path Attributes）**：这些属性用于 BGP 的路径选择算法。包括：

- **Weight**：Cisco 专有，只在本地路由器有效，值越高，路径越优先。
- **Local preference**：在同一 AS 内部的所有路由器之间广播，值越高，路径越优先。
- **Multi Exit Discriminator or MED**：在不同 AS 之间交换，值越低，路径越优先。
- **Origin**：表示路由信息的来源。
- **AS-Path**：包含了到达目标网络所经过的所有自治系统（AS）的列表。
- **Next-Hop**：下一跳路由器的 IP 地址。
- **Community**：用于控制路由的传播。

**路由选择（Route Selection）**：BGP 使用一系列的规则来决定最佳路径。

1. **优先选择权重（Weight）最高的路由**：权重是 Cisco 定义的属性，只在本地路由器有效。权重值越高，路径越优先。
2. **优先选择本地优先级（Local Preference）最高的路由**：本地优先级是在同一 AS 内部的所有路由器之间广播的属性。本地优先级值越高，路径越优先。
3. **优先选择本地生成（Locally Originated）的路由**：如果路由是由本地路由器生成的，那么它将被优先选择。
4. **优先选择 AS 路径最短的路由**：AS 路径是一个包含了到达目标网络所经过的所有自治系统（AS）的列表。路径中的 AS 数量越少，该路径就被认为越优先。
5. **优先选择已知的 IGP 路由而非未知的 IGP 路由**：如果路由是由内部网关协议（IGP）如 OSPF 或 IS-IS 学习到的，那么它将被优先选择。
6. **优先选择 MED 值最低的路由**：MED（Multi-Exit Discriminator）是一个在不同 AS 之间交换的可选属性。MED 值越低，路径越优先。
7. **优先选择 eBGP 路由而非 iBGP 路由**：如果两条路由的其他属性都相同，那么从外部 BGP（eBGP）学习到的路由将被优先选择。
8. **优先选择下一跳的度量值（Metric）最低的路由**：如果两条路由的其他属性都相同，那么下一跳的度量值最低的路由将被优先选择。
9. **优先选择已存在的最佳路径而非新学习到的路由**：如果两条路由的其他属性都相同，那么已存在的最佳路径将被优先选择。
10. **优先选择 RID 值最低的路由**：如果两条路由的其他属性都相同，那么 RID（Router ID）值最低的路由将被优先选择。
11. **如果 RID 相同，优先选择 IP 地址较低的路由**：如果两条路由的 RID 相同，那么 IP 地址较低的路由将被优先选择。

最常见的控制上述属性的方法是使用路由图（route maps）。这允许在特定的路由上改变特定的属性。

以上信息的详细解释和更多的 BGP 路由属性，你可以在以下资源中找到：

- [Cisco - BGP Path Attributes](https://www.cisco.com/c/en/us/support/docs/ip/border-gateway-protocol-bgp/13753-25.html)
- [RFC 4271 - A Border Gateway Protocol 4 (BGP-4)](https://tools.ietf.org/html/rfc4271)
