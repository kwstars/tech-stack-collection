## IPsec

### `reqid`

`reqid` 是一个可选的参数，用于标识一组具有相同需求的 IPsec 状态。当你有多个 IPsec 状态，但它们需要应用相同的策略时，可以使用相同的 `reqid`。这样，当匹配到一个具有特定 `reqid` 的策略时，所有具有相同 `reqid` 的状态都会被应用。

假设你有两个不同的网络，每个网络都有自己的一组 IPsec 状态。这两个网络可能有不同的安全需求，因此你可能希望对它们应用不同的 IPsec 策略。在这种情况下，你可以为每个网络的状态分配一个唯一的 `reqid`。

例如，你可以为第一个网络的状态分配 `reqid 1`，并为第二个网络的状态分配 `reqid 2`。然后，你可以创建两个策略，一个匹配 `reqid 1`，另一个匹配 `reqid 2`。这样，当一个数据包到达时，它会被匹配到一个具有相应 `reqid` 的策略，并应用相应的状态。

### `aead`

`aead` 是 "Authenticated Encryption with Associated Data" 的缩写，它是一种同时提供数据加密和数据完整性校验的加密模式。`aead "rfc4106(gcm(aes))"` 表示使用 AES-GCM（Galois/Counter Mode）加密算法。AES-GCM 是一种同时提供加密和数据完整性校验的加密模式，它是由 NIST（美国国家标准与技术研究院）在 RFC 4106 中定义的。

```bash
# SPI (Security Parameter Index) or reqid
dd if=/dev/urandom count=4 bs=1 2> /dev/null |  xxd -p -c 8

# aead "rfc4106(gcm(aes))"
dd if=/dev/urandom count=20 bs=1 2> /dev/null |  xxd -p -c 40
```

### `mode`

在 IPsec 配置中，`mode` 参数用于指定 IPsec 隧道的模式。有两种模式可以选择：

1. `tunnel`：在隧道模式下，整个 IP 数据包都会被加密，并在其前面添加一个新的 IP 头。这意味着原始的 IP 头（包括源 IP 和目标 IP）都会被加密。这种模式通常用于 VPN 或其他需要加密整个 IP 数据包的场景。
2. `transport`：在传输模式下，只有 IP 数据包的有效载荷（payload）会被加密，而 IP 头部则不会被加密。这种模式通常用于端到端的加密，例如在同一网络中的两台主机之间。

## WireShark

在 Wireshark 中，你可以通过以下步骤来设置 IPsec 解密：

1. 打开 Wireshark 并开始捕获数据包。
2. 在菜单栏中，选择 "Edit" -> "Preferences"。
3. 在左侧的列表中，展开 "Protocols"，然后滚动到底部并找到 "ESP"。
4. 在右侧的 "ESP SAs" 部分，点击 "Edit" 按钮。
5. 在弹出的窗口中，点击 "New" 按钮来添加一个新的安全关联（SA）。
6. 在 "SA Details" 部分，填写以下信息：
   - SPI: `0x12345678`（这是你的命令中指定的 SPI）
   - Encryption algorithm: AES-GCM with 16 octet ICV [RFC4106]
   - Encryption key: `0x40f3001f748d6428725f148fb14a3c5ec142cdc1`
   - Authentication: Null
   - Authentication key: 空
7. 点击 "OK" 按钮来保存你的设置。

## 用户空间的实现

- strongSwan 是一个开源的 IPsec-based VPN 解决方案，它支持 IKEv1 和 IKEv2 协议，以及许多现代的加密算法。strongSwan 提供了丰富的配置选项，可以满足各种复杂的网络需求。strongSwan 还提供了一个用户友好的 GUI，可以方便地管理 VPN 连接。
- Libreswan 是一个从 Openswan 分支出来的项目，它也是一个开源的 IPsec-based VPN 解决方案。Libreswan 支持 IKEv1 和 IKEv2 协议，以及许多现代的加密算法。Libreswan 的配置相对简单，适合需要快速部署 VPN 的场景。

## 内核空间的实现

- XFRM 是 Linux 内核中的一个子系统，它提供了 IPsec 的底层实现。XFRM 与 Netfilter 框架一起工作，处理 IPsec 的数据包。然而，XFRM 本身并不提供工具来配置 IPsec 策略和密钥。这些任务通常由用户空间的工具，如 strongSwan 或 Libreswan 完成，它们使用 XFRM 提供的接口来管理 IPsec 策略和密钥。

## 参考和引用

- https://ibug.io/blog/2021/10/linux-ipsec-with-ip-xfrm/
