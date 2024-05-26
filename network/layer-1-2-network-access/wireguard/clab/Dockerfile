FROM ubuntu:22.04

RUN sed -i 's/archive.ubuntu.com/mirrors.aliyun.com/g' /etc/apt/sources.list && \
  apt update && apt install -y \
  bash-completion \
  bridge-utils \
  conntrack \
  coreutils \
  curl \
  dnsutils \
  iproute2 \
  iptables \
  iputils-ping \
  net-tools \
  nftables \
  nmap \
  ethtool \
  tcpdump \
  traceroute \
  wireguard-tools \
  && rm -rf /var/lib/apt/lists/*
