#!/bin/sh
# 启动 tcpdump 在后台抓包，保存到 /tmp/tcpdump.pcap
tcpdump -pen -i any -w /pcap/h2.pcap &
# 启动 Nginx
exec nginx -g 'daemon off;'
