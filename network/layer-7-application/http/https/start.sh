#!/bin/sh
tcpdump -pen -i any -w /pcap/https.pcap &
exec nginx -g 'daemon off;'
