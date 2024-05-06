#!/bin/bash
set -v

# Change the apt source to Aliyun
sudo sed -i 's#http://archive.ubuntu.com#https://mirrors.aliyun.com#' /etc/apt/sources.list

# Install the necessary tools
sudo apt-get update -qq && sudo apt-get install -y bridge-utils net-tools bash-completion make

# Install ContainerLab
bash -c "$(curl -sL https://get.containerlab.dev)"

# Install Docker
sudo apt-get update -qq && sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://mirrors.aliyun.com/docker-ce/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://mirrors.aliyun.com/docker-ce/linux/ubuntu $(lsb_release -cs) stable"
sudo apt-get update -qq && sudo apt-get -y install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
sudo usermod -aG docker ${USER}

# Download Docker completion script
sudo curl -L https://raw.githubusercontent.com/docker/cli/master/contrib/completion/bash/docker -o /etc/bash_completion.d/docker

# # Enable bash completion
# echo 'source /etc/bash_completion' >>~/.bashrc
