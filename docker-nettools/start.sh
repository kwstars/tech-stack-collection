#!/bin/bash

# Define color codes
LIGHT_BLUE='\033[1;34m'
LIGHT_GREEN='\033[1;32m'
LIGHT_CYAN='\033[1;36m'
LIGHT_PURPLE='\033[1;35m'
NC='\033[0m' # No Color

# POD_NAME=$(cat /etc/podinfo/labels | grep pod-template-hash | cut -d'=' -f2)
NAME=$HOSTNAME
POD_NAMESPACE=$(cat /var/run/secrets/kubernetes.io/serviceaccount/namespace)
POD_IP=$(hostname -i)
MAC_ADDRESS=$(ip link show eth0 | awk '/ether/ {print $2}')

echo -e "${LIGHT_BLUE}Name: $NAME${NC}, ${LIGHT_GREEN}Namespace: $POD_NAMESPACE${NC}, ${LIGHT_CYAN}IP: $POD_IP${NC}, ${LIGHT_PURPLE}MAC Address of eth0: $MAC_ADDRESS${NC}" >/usr/share/nginx/html/index.html

nginx -g 'daemon off;'
