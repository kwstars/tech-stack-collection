## 设置代理

在 Kind 中配置网络代理以便拉取镜像时使用代理，可以通过设置 Docker 守护进程的代理配置来实现。以下是步骤说明：

### 1. 配置 Docker 守护进程

首先，你需要在 Docker 中设置代理。编辑或创建 Docker 的守护进程配置文件：

```bash
sudo mkdir -p /etc/systemd/system/docker.service.d/
sudo nano /etc/systemd/system/docker.service.d/http-proxy.conf
```

在这个文件中，添加如下内容，根据你的代理地址修改 `httpProxy` 和 `httpsProxy`：

```ini
[Service]
Environment="HTTP_PROXY=http://your-proxy-address:port/"
Environment="HTTPS_PROXY=http://your-proxy-address:port/"
Environment="NO_PROXY=localhost,127.0.0.1"
```

**注意**：`NO_PROXY` 列表可以根据需要进行调整，确保本地网络通信不经过代理。

### 2. 重启 Docker 服务

设置完代理后，需要重启 Docker 服务以应用配置：

```bash
sudo systemctl daemon-reload
sudo systemctl restart docker
```

### 3. 配置 Kind 集群

在 Kind 中启动集群时，可以指定 `config` 文件来配置网络代理。下面是一个示例配置文件：

```yaml
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
nodes:
  - role: control-plane
    extraPortMappings:
      - containerPort: 80
        hostPort: 80
        protocol: TCP
    extraMounts:
      - hostPath: /etc/systemd/system/docker.service.d/http-proxy.conf
        containerPath: /etc/systemd/system/docker.service.d/http-proxy.conf
      - hostPath: /etc/systemd/system/docker.service.d/https-proxy.conf
        containerPath: /etc/systemd/system/docker.service.d/https-proxy.conf
    extraEnvs:
      - name: HTTP_PROXY
        value: "http://your-proxy-address:port"
      - name: HTTPS_PROXY
        value: "http://your-proxy-address:port"
      - name: NO_PROXY
        value: "localhost,127.0.0.1"
```

创建集群时使用这个配置：

```bash
kind create cluster --config kind-config.yaml
```

### 4. 验证配置

可以通过以下命令验证代理是否生效：

```bash
docker info | grep -i proxy
```

如果输出中包含配置的代理地址，说明配置成功。

### 5. 使用私有镜像仓库（可选）

如果你有私有镜像仓库，也可以在 Kind 配置文件中指定镜像仓库地址：

```yaml
containerdConfigPatches:
  - |-
    [plugins."io.containerd.grpc.v1.cri".registry]
      [plugins."io.containerd.grpc.v1.cri".registry.mirrors]
        [plugins."io.containerd.grpc.v1.cri".registry.mirrors."docker.io"]
          endpoint = ["http://localhost:5000"]
        [plugins."io.containerd.grpc.v1.cri".registry.mirrors."gcr.io"]
          endpoint = ["http://localhost:5001"]
```

1. **`containerdConfigPatches`**:这是一个配置项，用于指定 `containerd` 的配置补丁。它通常用于在现有配置的基础上进行修改或添加。
2. **`- |-`**: 这是 YAML 语法，用于表示多行字符串。`|-` 表示保留换行符的多行字符串。
3. **`[plugins."io.containerd.grpc.v1.cri".registry]`**: 这是 TOML 语法，用于指定 `containerd` 的插件配置。`plugins."io.containerd.grpc.v1.cri".registry` 表示配置 `containerd` 的 `CRI` 插件的注册表设置。
4. **`[plugins."io.containerd.grpc.v1.cri".registry.mirrors]`**: 这是 `registry` 配置的子项，表示镜像注册表的镜像配置。
5. **`[plugins."io.containerd.grpc.v1.cri".registry.mirrors."docker.io"]`**: 这是为特定的镜像注册表（在这里是 `docker.io`）配置镜像设置。 `docker.io` 是 Docker 官方的镜像注册表。
6. **`endpoint = ["http://your-proxy-address:port"]`**: 这是为 `docker.io` 注册表配置的镜像代理地址。 `endpoint` 是一个列表，包含一个或多个代理地址。 `http://your-proxy-address:port` 是代理服务器的地址和端口，用户需要将其替换为实际的代理地址和端口。

这段配置的作用是为 `containerd` 配置一个镜像代理。当 `containerd` 从 `docker.io` 拉取镜像时，会通过指定的代理地址（`http://your-proxy-address:port`）进行请求。这在需要通过代理服务器访问外部镜像注册表时非常有用。
