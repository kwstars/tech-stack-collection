#!/bin/bash
set -o errexit
set -o verbose
set -o nounset

# Switch to the script's directory
cd "$(dirname "$0")"

# 1.prep noCNI env
cat <<EOF | kind create cluster --name=flannel-ipip --image=mykindest/node:v1.28.7 --config=-
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
networking:
  disableDefaultCNI: true
  podSubnet: "10.244.0.0/16"
nodes:
  - role: control-plane
    extraMounts:
      - hostPath: /opt/cni/bin/
        containerPath: /opt/cni/bin
      - hostPath: .
        containerPath: /data
  - role: worker
    extraMounts:
      - hostPath: /opt/cni/bin/
        containerPath: /opt/cni/bin
      - hostPath: .
        containerPath: /data
  - role: worker
    extraMounts:
      - hostPath: /opt/cni/bin/
        containerPath: /opt/cni/bin
      - hostPath: .
        containerPath: /data
containerdConfigPatches:
  - |-
    [plugins."io.containerd.grpc.v1.cri".registry.mirrors."10.0.0.10:5000"]
      endpoint = ["http://10.0.0.10:5000"]
EOF

# 2.remove taints
kubectl taint nodes $(kubectl get nodes --no-headers -o custom-columns=NAME:.metadata.name | grep control-plane) node-role.kubernetes.io/control-plane:NoSchedule-
kubectl get nodes -o wide

# 3.install CNI
# https://github.com/flannel-io/flannel/releases/download/v0.25.1/kube-flannel.yml
kubectl apply -f ./flannel.yaml

# 4. Run a test pod
cat <<EOF | kubectl apply -f -
apiVersion: apps/v1
kind: DaemonSet
metadata:
  labels:
    app: test-ds
  name: test-ds
spec:
  selector:
    matchLabels:
      app: test-ds
  template:
    metadata:
      labels:
        app: test-ds
    spec:
      containers:
        - image: 10.0.0.10:5000/wbitt/network-multitool
          name: nettoolbox
          securityContext:
            privileged: true
---
apiVersion: v1
kind: Service
metadata:
  name: serversvc
spec:
  type: NodePort
  selector:
    app: test-ds
  ports:
    - name: test-ds
      port: 8080
      targetPort: 80
      nodePort: 32000
EOF

# Captrue packet
docker exec -d flannel-ipip-control-plane bash -c "tcpdump -pen -i eth0 'ip proto 4' -w /data/control-eth0.pcap"
