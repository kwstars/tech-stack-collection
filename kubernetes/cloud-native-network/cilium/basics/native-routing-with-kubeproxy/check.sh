#!/bin/bash

docker exec -it basics-vxlan-with-kubeproxy-default-control-plane iptables-save | grep 32000
