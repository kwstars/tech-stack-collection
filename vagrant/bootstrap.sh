#!/bin/bash
set -v
set -e

# Change the apt source to Aliyun
sudo sed -i 's#http://archive.ubuntu.com#https://mirrors.aliyun.com#' /etc/apt/sources.list

# Install the necessary tools
sudo apt-get update -qq && sudo apt-get install -y bridge-utils net-tools bash-completion make apt-transport-https ca-certificates curl software-properties-common

# Install ContainerLab
bash -c "$(curl -sL https://get.containerlab.dev)"
# bash -c "$(curl -sL https://get.containerlab.dev)" -- -v 0.54.0

# Install Docker
curl -fsSL https://mirrors.aliyun.com/docker-ce/linux/ubuntu/gpg | sudo apt-key add -
if ! grep -q "^deb .*docker-ce" /etc/apt/sources.list /etc/apt/sources.list.d/*; then
  sudo add-apt-repository "deb [arch=amd64] https://mirrors.aliyun.com/docker-ce/linux/ubuntu $(lsb_release -cs) stable"
fi
sudo apt-get update -qq && sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
sudo usermod -aG docker vagrant
cat <<EOF | sudo tee /etc/docker/daemon.json
{
  "registry-mirrors": ["https://registry.docker-cn.com"]
}
EOF
sudo systemctl restart docker

# Install kubectl
curl -fsSL https://mirrors.aliyun.com/kubernetes-new/core/stable/v1.28/deb/Release.key |
  sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
echo "deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://mirrors.aliyun.com/kubernetes-new/core/stable/v1.28/deb/ /" |
  sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update -qq && sudo apt-get install -y kubectl

# Calico
sudo curl -L https://github.com/projectcalico/calico/releases/download/v3.27.3/calicoctl-linux-amd64 -o /usr/local/bin/calicoctl
sudo chmod +x /usr/local/bin/calicoctl

# Download Docker completion script
# sudo curl -L https://raw.githubusercontent.com/docker/cli/master/contrib/completion/bash/docker -o /etc/bash_completion.d/docker
clab completion bash | sudo tee /etc/bash_completion.d/clab >/dev/null
kind completion bash | sudo tee /etc/bash_completion.d/kind >/dev/null
# https://kubernetes.io/docs/reference/kubectl/quick-reference/
source <(kubectl completion bash)                                        # set up autocomplete in bash into the current shell, bash-completion package should be installed first.
echo "source <(kubectl completion bash)" >/etc/bash_completion.d/kubectl # add autocomplete permanently to your bash shell.
