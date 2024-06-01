K3S_VERSION = "v1.28.8+k3s1"

SUDO := $(if $(shell id -u),sudo,)

.PHONY: prepare move-images move-binary install

prepare:
	if [ ! -f k3s ]; then wget -O k3s https://github.com/k3s-io/k3s/releases/download/$(K3S_VERSION)/k3s; fi
	if [ ! -f k3s-airgap-images-amd64.tar.gz ]; then wget -O k3s-airgap-images-amd64.tar.gz https://github.com/k3s-io/k3s/releases/download/$(K3S_VERSION)/k3s-airgap-images-amd64.tar.gz; fi
	if [ ! -f install.sh ]; then wget -O install.sh https://get.k3s.io/; fi

move-images: prepare
	$(SUDO) mkdir -p /var/lib/rancher/k3s/agent/images/
	$(SUDO) cp -f k3s-airgap-images-amd64.tar.gz /var/lib/rancher/k3s/agent/images/

move-binary:
	$(SUDO) cp -f k3s /usr/local/bin/
	$(SUDO) chmod +x /usr/local/bin/k3s

# 请将<node-ip>, <advertise-address>, <tls-san> 替换为节点的IP
# 如果网络问题可以配置代理: https://docs.k3s.io/advanced#configuring-an-http-proxy
# token: /var/lib/rancher/k3s/server/node-token    https://docs.k3s.io/cli/token?_highlight=token#server
# kubeconfig: /etc/rancher/k3s/k3s.yaml    https://docs.k3s.io/cluster-access
install-server-node: move-images move-binary
	INSTALL_K3S_EXEC="server --write-kubeconfig ~/.kube/config --disable=traefik --node-ip 10.0.0.132 --advertise-address 10.0.0.132 --default-local-storage-path /data/local-storage" INSTALL_K3S_SKIP_DOWNLOAD=true INSTALL_K3S_VERSION=$(K3S_VERSION) bash ./install.sh

# 请将<token>替换为主节点的token，<主节点IP>替换为主节点的IP
install-agent-node: move-images move-binary
	INSTALL_K3S_EXEC="agent --token <token> --server https://<主节点IP>:6443 --node-label k3s.io/hostname=$(shell hostname)" INSTALL_K3S_SKIP_DOWNLOAD=true INSTALL_K3S_VERSION=$(K3S_VERSION) bash ./install.sh

uninstall-server-node:
	$(SUDO) /usr/local/bin/k3s-uninstall.sh

uninstall-agent-node:
	$(SUDO) /usr/local/bin/k3s-agent-uninstall.sh

clean:
	rm -f k3s k3s-airgap-images-amd64.tar.gz install.sh
