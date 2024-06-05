#!/bin/bash

NAMESPACE="kube-system"
DAEMONSET="cilium"

POD=$(kubectl -n "$NAMESPACE" get pods -l k8s-app="$DAEMONSET" -o jsonpath='{.items[0].metadata.name}')

COMMAND='cilium-dbg status | grep -A 1 "Host Routing"'

kubectl exec -n "$NAMESPACE" -it "$POD" -- sh -c "$COMMAND"

# Host Routing:                                                  Legacy
# Masquerading:                                                  IPTables [IPv4: Enabled, IPv6: Disabled]
