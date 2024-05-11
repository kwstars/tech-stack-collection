## [Flannel 支持的后端（backends）](https://github.com/flannel-io/flannel/blob/master/Documentation/backends.md)

1. **VXLAN**：使用内核中的 VXLAN 来封装数据包。

   - 直接路由（Direct Routing）：在这种模式下，当目标 Pod 位于同一节点时，数据包直接通过节点的网络发送，不需要进行 VXLAN 封装。当目标 Pod 位于不同节点时，数据包会被封装到 VXLAN 中，然后通过节点的网络发送到目标节点，最后在目标节点上解封装并发送到目标 Pod。这种模式的优点是性能较好，因为在同一节点上的 Pod 之间的通信不需要进行 VXLAN 封装和解封装。但是，这种模式需要节点的网络支持直接路由。
   - 隧道（Tunneling）：在这种模式下，无论目标 Pod 是否位于同一节点，数据包都会被封装到 VXLAN 中，然后通过节点的网络发送。如果目标 Pod 位于同一节点，数据包会在发送前被封装到 VXLAN 中，然后立即在同一节点上解封装并发送到目标 Pod。如果目标 Pod 位于不同节点，数据包会被封装到 VXLAN 中，然后通过节点的网络发送到目标节点，最后在目标节点上解封装并发送到目标 Pod。这种模式的优点是兼容性较好，因为它不需要节点的网络支持直接路由。但是，这种模式的性能可能较差，因为所有的通信都需要进行 VXLAN 封装和解封装。

2. **host-gw**：使用 host-gw 创建到子网的 IP 路由，通过远程机器的 IP。这需要主机之间具有直接的 layer2 连接。
3. **WireGuard**：使用内核中的 WireGuard 来封装和加密数据包。
4. **UDP**：仅在网络和内核阻止使用 VXLAN 或 host-gw 时使用 UDP 进行调试。

以下是正在试验阶段的（生产环境不建议使用）：

1. **Alloc**：执行子网分配，但不转发数据包。
2. **TencentCloud VPC**：在腾讯云 VPC 中创建 IP 路由，当在腾讯云 VPC 中运行时，这可以减少创建单独的 flannel 接口的需要。
3. **IPIP**：使用内核中的 IPIP 来封装数据包。
4. **IPSec**：使用内核中的 IPSec 来封装和加密数据包。

### VXLAN

#### 跨主机 Pod 之间通信

从控制节点的 Pod 到 worker 节点的流量

```bash
$ kubectl get pod -o wide
NAME            READY   STATUS    RESTARTS   AGE   IP           NODE                          NOMINATED NODE   READINESS GATES
test-ds-5tgnt   1/1     Running   0          11m   10.244.1.2   flannel-vxlan-worker2         <none>           <none>
test-ds-7w6gz   1/1     Running   0          11m   10.244.2.2   flannel-vxlan-worker          <none>           <none>
test-ds-k6zt9   1/1     Running   0          11m   10.244.0.2   flannel-vxlan-control-plane   <none>           <none>

# 在主节点的 Pod 获取路由信息
$ kubectl exec -it test-ds-k6zt9 -- ip route
default via 10.244.0.1 dev eth0
10.244.0.0/24 dev eth0 proto kernel scope link src 10.244.0.2
10.244.0.0/16 via 10.244.0.1 dev eth0

# 在主节点的 Pod 获取宿主机的对应接口的 MAC
$ kubectl exec -it test-ds-k6zt9 -- arp -n
$ kubectl exec -it test-ds-k6zt9 -- ping -c 1 10.244.2.2
$ kubectl exec -it test-ds-k6zt9 -- arp -n
Address                  HWtype  HWaddress           Flags Mask            Iface
10.244.0.1               ether   56:9f:51:21:b6:d9   C                     eth0

# 根据宿主机的 MAC（56:9f:51:21:b6:d9） 获取接口
$ docker exec -it flannel-vxlan-control-plane ip a | grep -A 5 "cni0:"
4: cni0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1450 qdisc noqueue state UP group default qlen 1000
    link/ether 56:9f:51:21:b6:d9 brd ff:ff:ff:ff:ff:ff
    inet 10.244.0.1/24 brd 10.244.0.255 scope global cni0
       valid_lft forever preferred_lft forever
    inet6 fe80::549f:51ff:fe21:b6d9/64 scope link
       valid_lft forever preferred_lft forever

# 根据宿主机路由获取封装的接口
$ docker exec -it flannel-vxlan-control-plane ip r
default via 172.18.0.1 dev eth0
10.244.0.0/24 dev cni0 proto kernel scope link src 10.244.0.1
10.244.1.0/24 via 10.244.1.0 dev flannel.1 onlink
10.244.2.0/24 via 10.244.2.0 dev flannel.1 onlink
172.18.0.0/16 dev eth0 proto kernel scope link src 172.18.0.4

# 获取 "10.244.2.0" 的 MAC 并在 fdb 里面查询 Overlay 封装的目的地地址 172.18.0.2
$ docker exec -it flannel-vxlan-control-plane sh -c 'ip neigh show | grep "10.244.2.0" | awk "{print \$5}" | xargs -I {} sh -c "bridge fdb show | grep {}"'
d6:12:8b:51:3a:5a dev flannel.1 dst 172.18.0.2 self permanent

# 本地 Overlay 封装地址 172.18.0.4
$ docker exec -it flannel-vxlan-control-plane ip a | grep -A7 "eth0"
283: eth0@if284: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default
    link/ether 02:42:ac:12:00:04 brd ff:ff:ff:ff:ff:ff link-netnsid 0
    inet 172.18.0.4/16 brd 172.18.255.255 scope global eth0
       valid_lft forever preferred_lft forever
    inet6 fc00:f853:ccd:e793::4/64 scope global nodad
       valid_lft forever preferred_lft forever
    inet6 fe80::42:acff:fe12:4/64 scope link
       valid_lft forever preferred_lft forever

# Flannel 监听的地址
$ docker exec -it flannel-vxlan-control-plane ss -tnulp | grep 8472
Netid          State           Recv-Q          Send-Q                   Local Address:Port                      Peer Address:Port          Process
udp            UNCONN          0               0                              0.0.0.0:8472                           0.0.0.0:*
```

### Calico

在网络术语中，路由（Route）和转发数据库（Forwarding Database, FDB）是两个不同的概念，它们在网络设备中起着不同的作用。

1. 路由（Route）：路由是网络层（OSI 模型的第三层）的概念，它描述了数据包从源地址到目的地址的路径。路由表是存储路由信息的数据结构，它包含了目的网络或主机的地址，下一跳地址，以及到达目的地的成本等信息。路由器使用路由表来决定如何转发数据包。

2. 转发数据库（FDB）：FDB 是数据链路层（OSI 模型的第二层）的概念，它通常在交换机中使用。FDB 存储了 MAC 地址到交换机端口的映射，交换机使用 FDB 来决定如何转发帧。

简单来说，路由和 FDB 的关系是：路由决定了数据包在网络层的路径，而 FDB 决定了帧在数据链路层的路径。在一个典型的网络设备中，路由和 FDB 会一起工作，确保数据能够从源地址正确地传输到目的地址。

1. IPIP
2. IPIP Cross subnet
3. [VXLAN](https://docs.tigera.io/calico/latest/getting-started/kubernetes/self-managed-onprem/config-options#switching-from-ip-in-ip-to-vxlan)
4. VXLAN Cross subne

## 问题

### [failed to open TUN device: open /dev/net/tun: no such file or directory](https://github.com/flannel-io/flannel/issues/1267)

使用 UDP 模式的报错，报错日志如下：

```bash
# kubectl get pods -A
NAMESPACE            NAME                                                READY   STATUS              RESTARTS       AGE
kube-flannel         kube-flannel-ds-b9pmh                               0/1     CrashLoopBackOff    6 (111s ago)   8m8s
kube-flannel         kube-flannel-ds-m4fgh                               0/1     CrashLoopBackOff    6 (28s ago)    8m8s
kube-flannel         kube-flannel-ds-wd7hs                               0/1     CrashLoopBackOff    6 (56s ago)    8m8s
kube-system          coredns-5d78c9869d-859jv                            0/1     ContainerCreating   0              8m16s
kube-system          coredns-5d78c9869d-pcjtz                            0/1     ContainerCreating   0              8m16s
kube-system          etcd-flannel-udp-control-plane                      1/1     Running             0              8m32s
kube-system          kube-apiserver-flannel-udp-control-plane            1/1     Running             0              8m30s
kube-system          kube-controller-manager-flannel-udp-control-plane   1/1     Running             0              8m30s
kube-system          kube-proxy-dtb7k                                    1/1     Running             0              8m16s
kube-system          kube-proxy-k4jd7                                    1/1     Running             0              8m9s
kube-system          kube-proxy-x9ft9                                    1/1     Running             0              8m11s
kube-system          kube-scheduler-flannel-udp-control-plane            1/1     Running             0              8m30s
local-path-storage   local-path-provisioner-5b77c697fd-hq4xz             0/1     ContainerCreating   0              8m16s

# kubectl logs kube-flannel-ds-m4fgh -n kube-flannel --previous
Defaulted container "kube-flannel" out of: kube-flannel, install-cni-plugin (init), install-cni (init)
I0510 02:00:16.779320       1 main.go:209] CLI flags config: {etcdEndpoints:http://127.0.0.1:4001,http://127.0.0.1:2379 etcdPrefix:/coreos.com/network etcdKeyfile: etcdCertfile: etcdCAFile: etcdUsername: etcdPassword: version:false kubeSubnetMgr:true kubeApiUrl: kubeAnnotationPrefix:flannel.alpha.coreos.com kubeConfigFile: iface:[] ifaceRegex:[] ipMasq:true ifaceCanReach: subnetFile:/run/flannel/subnet.env publicIP: publicIPv6: subnetLeaseRenewMargin:60 healthzIP:0.0.0.0 healthzPort:0 iptablesResyncSeconds:5 iptablesForwardRules:true netConfPath:/etc/kube-flannel/net-conf.json setNodeNetworkUnavailable:true}
W0510 02:00:16.779388       1 client_config.go:618] Neither --kubeconfig nor --master was specified.  Using the inClusterConfig.  This might not work.
I0510 02:00:16.790932       1 kube.go:139] Waiting 10m0s for node controller to sync
I0510 02:00:16.790987       1 kube.go:461] Starting kube subnet manager
I0510 02:00:16.794741       1 kube.go:482] Creating the node lease for IPv4. This is the n.Spec.PodCIDRs: [10.244.0.0/24]
I0510 02:00:16.794761       1 kube.go:482] Creating the node lease for IPv4. This is the n.Spec.PodCIDRs: [10.244.1.0/24]
I0510 02:00:16.794766       1 kube.go:482] Creating the node lease for IPv4. This is the n.Spec.PodCIDRs: [10.244.2.0/24]
I0510 02:00:17.791694       1 kube.go:146] Node controller sync successful
I0510 02:00:17.791747       1 main.go:229] Created subnet manager: Kubernetes Subnet Manager - flannel-udp-worker
I0510 02:00:17.791753       1 main.go:232] Installing signal handlers
I0510 02:00:17.791908       1 main.go:452] Found network config - Backend type: udp
I0510 02:00:17.791991       1 match.go:210] Determining IP address of default interface
I0510 02:00:17.792177       1 match.go:263] Using interface with name eth0 and address 172.18.0.3
I0510 02:00:17.792223       1 match.go:285] Defaulting external address to interface address (172.18.0.3)
E0510 02:00:17.792317       1 main.go:332] Error registering network: failed to open TUN device: open /dev/net/tun: no such file or directory
I0510 02:00:17.792439       1 main.go:432] Stopping shutdownHandler...
```

两种解决方法：

1. 方法一: `securityContext` 的 privileged 设置为 true
2. 方法二：将 `/dev/net/tun` 挂载到容器中

### [failed to find plugin "bridge" in path [/opt/cni/bin]](https://routemyip.com/posts/k8s/setup/flannel/)

CoreDNS 不创建，然后查看 CoreDNS Pod 的详细信息，如下：

```bash
# kubectl describe pod -n kube-system coredns-5d78c9869d-2w2wq
......
Events:
  Type     Reason                  Age               From               Message
  ----     ------                  ----              ----               -------
  Warning  FailedScheduling        44s               default-scheduler  0/1 nodes are available: 1 node(s) had untolerated taint {node.kubernetes.io/not-ready: }. preemption: 0/1 nodes are available: 1 Preemption is not helpful for scheduling..
  Normal   Scheduled               33s               default-scheduler  Successfully assigned kube-system/coredns-5d78c9869d-2w2wq to flannel-udp-control-plane
  Warning  FailedCreatePodSandBox  33s               kubelet            Failed to create pod sandbox: rpc error: code = Unknown desc = failed to setup network for sandbox "6270f643b85a995593b8b15b6100e2b6319cbe2e24ae9cc462b6c8ed6bbca7ff": plugin type="flannel" failed (add): loadFlannelSubnetEnv failed: open /run/flannel/subnet.env: no such file or directory
  Warning  FailedCreatePodSandBox  18s               kubelet            Failed to create pod sandbox: rpc error: code = Unknown desc = failed to setup network for sandbox "a697284ce594b6a035f060d60a4dd3244ee92970bcc2de1df4e31eb86ae28125": plugin type="flannel" failed (add): failed to delegate add: failed to find plugin "bridge" in path [/opt/cni/bin]
  Warning  FailedCreatePodSandBox  18s               kubelet            Failed to create pod sandbox: rpc error: code = Unknown desc = failed to setup network for sandbox "1d479c6b8f6bfa353a6610ac1168366cc5c9d98d22517118b547c44cd4ad7418": plugin type="flannel" failed (add): failed to delegate add: failed to find plugin "bridge" in path [/opt/cni/bin]
  Normal   SandboxChanged          3s (x3 over 18s)  kubelet            Pod sandbox changed, it will be killed and re-created.
  Warning  FailedCreatePodSandBox  3s (x2 over 17s)  kubelet            Failed to create pod sandbox: rpc error: code = Unknown desc = failed to reserve sandbox name "coredns-5d78c9869d-2w2wq_kube-system_a873eb8c-e6b9-4409-8c4d-020ee6a924f3_1": name "coredns-5d78c9869d-2w2wq_kube-system_a873eb8c-e6b9-4409-8c4d-020ee6a924f3_1" is reserved for "1d479c6b8f6bfa353a6610ac1168366cc5c9d98d22517118b547c44cd4ad7418"
```

下载 plugins

```bash
$ curl -L -o cni-plugins.tgz https://github.com/containernetworking/plugins/releases/download/v1.4.1/cni-plugins-linux-amd64-v1.4.1.tgz
$ sudo mkdir -p /opt/cni/bin
$ sudo tar -C /opt/cni/bin -xzf cni-plugins.tgz
```
