## 简介

BGP (Border Gateway Protocol) 是一种路径向量协议，主要用于在自治系统（AS）之间进行路由信息的交换。BGP 是互联网的主要路由协议，它允许网络管理员通过设置路由策略来控制路由信息的传播。

与 BGP 相比，IS-IS (Intermediate System to Intermediate System) 和 OSPF (Open Shortest Path First) 是两种链路状态协议，主要用于在自治系统内部进行路由信息的交换。

以下是 BGP 与 IS-IS 和 OSPF 的主要区别：

1. **路由信息的传播范围**：BGP 主要用于在 AS 之间进行路由信息的交换，而 IS-IS 和 OSPF 主要用于在 AS 内部进行路由信息的交换。
2. **路由计算的基础**：BGP 使用路径向量协议，它基于路径的属性（如 AS_PATH、NEXT_HOP 等）来选择最佳路径。而 IS-IS 和 OSPF 是链路状态协议，它们基于网络的拓扑结构来计算最短路径。
3. **路由策略的控制**：BGP 允许网络管理员通过设置路由策略来控制路由信息的传播，这在互联网中是非常重要的。而 IS-IS 和 OSPF 主要关注的是如何快速和准确地传播路由信息，它们提供的路由策略控制相对较少。
4. **收敛速度**：由于 BGP 需要处理的路由信息更多，且需要考虑路由策略，所以 BGP 的收敛速度通常比 IS-IS 和 OSPF 慢。
5. **扩展性**：BGP 由于其路径向量特性，具有良好的扩展性，能够处理大规模的网络。而 IS-IS 和 OSPF 由于需要维护完整的拓扑信息，所以在大规模网络中可能面临扩展性的问题。

## 协议工作过程

BGP (Border Gateway Protocol) 的协议工作过程如下：

1. **建立 TCP 连接**：BGP 使用 TCP 作为其传输协议，通过 TCP 端口 179 建立连接。

2. **打开 BGP 会话**：通过发送 OPEN 消息来打开 BGP 会话。OPEN 消息包含了 BGP 版本号、AS 号、Hold Time 等信息。

3. **保持 BGP 会话**：通过定期发送 KEEPALIVE 消息来保持 BGP 会话。

4. **交换路由信息**：BGP 通过 UPDATE 消息交换路由信息。每个 UPDATE 消息包含可以到达的新路由和不再可用的路由。

5. **路由决策**：BGP 使用一套复杂的路由决策算法来从所有收到的路由中选择最佳路由。

6. **广播路由信息**：BGP 将选择的最佳路由通过 UPDATE 消息广播给所有的 BGP 邻居。

### 报文

BGP (Border Gateway Protocol) 有四种类型的报文：

1. **OPEN**：用于打开一个 BGP 会话。OPEN 报文包含了 BGP 版本号、AS 号、Hold Time 等信息。

2. **UPDATE**：用于交换路由信息。每个 UPDATE 报文包含可以到达的新路由和不再可用的路由。

3. **KEEPALIVE**：用于保持 BGP 会话。如果在 Hold Time 时间内没有收到任何 BGP 报文，那么会发送 KEEPALIVE 报文来保持会话。

4. **NOTIFICATION**：用于报告错误信息。如果在 BGP 会话中发生错误，那么会发送 NOTIFICATION 报文来通知对方。

### 状态

BGP (Border Gateway Protocol) 在建立和维护邻居关系时，会经历以下六种状态：

1. **Idle 状态**：这是 BGP 的初始状态。在这个状态下，路由器拒绝所有入站的 BGP 连接。

2. **Connect 状态**：在这个状态下，路由器正在等待 TCP 连接的完成。

3. **Active 状态**：在这个状态下，路由器正在主动尝试建立 TCP 连接。

4. **OpenSent 状态**：在这个状态下，路由器已经发送了 OPEN 消息，并正在等待 OPEN 消息的确认。

5. **OpenConfirm 状态**：在这个状态下，路由器已经收到了 OPEN 消息的确认，并正在等待 KEEPALIVE 或 UPDATE 消息。

6. **Established 状态**：在这个状态下，路由器已经收到了 KEEPALIVE 或 UPDATE 消息，BGP 邻居关系已经建立，可以开始交换路由信息。

这六种状态共同支持 BGP 的邻居发现和路由信息交换过程。
