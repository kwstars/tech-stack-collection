#!/bin/sh

tcpdump -pen -i any -w /pcap/h2c.pcap &

exec nginx -g 'daemon off;'
