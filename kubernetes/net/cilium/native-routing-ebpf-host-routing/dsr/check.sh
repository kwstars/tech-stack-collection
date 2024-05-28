#!/bin/bash

NAMESPACE="kube-system"
DAEMONSET="cilium"
POD=$(kubectl -n "$NAMESPACE" get pods -l k8s-app="$DAEMONSET" -o jsonpath='{.items[0].metadata.name}')
COMMAND='cilium-dbg status --verbose | grep -A 10 "KubeProxyReplacement Details"'
kubectl exec -n "$NAMESPACE" -it "$POD" -- sh -c "$COMMAND"

# KubeProxyReplacement Details:
#   Status:                 True
#   Socket LB:              Enabled
#   Socket LB Tracing:      Enabled
#   Socket LB Coverage:     Full
#   Devices:                eth0  172.30.0.3 (Direct Routing)
#   Mode:                   DSR
#     DSR Dispatch Mode:    IP Option/Extension
