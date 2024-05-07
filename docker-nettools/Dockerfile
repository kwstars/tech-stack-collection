FROM nginx:1.25-bookworm

RUN apt update && apt install -y \
  bash \
  bash-completion \
  bridge-utils \
  conntrack \
  coreutils \
  curl \
  dnsutils \
  iperf3 \
  iproute2 \
  iptables \
  iputils-ping \
  keepalived \
  net-tools \
  nftables \
  nmap \
  ngrep \
  socat \
  ethtool \
  mtr-tiny \
  tcpdump \
  traceroute \
  busybox \
  lz4 \
  tshark \
  zstd && \
  rm -rf /var/lib/apt/lists/*

COPY start.sh /start.sh
RUN chmod +x /start.sh
CMD ["/start.sh"]
