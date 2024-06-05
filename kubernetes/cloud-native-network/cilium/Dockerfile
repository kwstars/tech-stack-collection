FROM kindest/node:v1.28.7

RUN apt update && \
  apt install -y tcpdump net-tools iputils-ping wireguard-tools curl && \
  curl -L https://github.com/projectcalico/calico/releases/download/v3.27.3/calicoctl-linux-amd64 -o /usr/local/bin/calicoctl && \
  chmod +x /usr/local/bin/calicoctl
