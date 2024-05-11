.PHONY: ipip-default ipip-cross-subnet vxlan vxlan-cross-subnet bgp-full-mesh

TARGETS = ipip-default ipip-cross-subnet vxlan vxlan-cross-subnet bgp-full-mesh

$(TARGETS):
	bash $@/run.sh

mykindest:
	docker build -t mykindest/node:v1.28.7 .

list:
	@sudo kind get clusters

clean-pcap:
	find . -name "*.pcap" -type f -delete


clean-ipip-cross-subnet:
	@if sudo clab inspect --all | grep -q 'calico-ipip-cross-subnet'; then sudo clab destroy -t ipip-cross-subnet/clab.yaml; fi
	@if ip link show br-pool0 > /dev/null 2>&1; then sudo ip link set br-pool0 down; sudo ip link del br-pool0; fi
	@if ip link show br-pool1 > /dev/null 2>&1; then sudo ip link set br-pool1 down; sudo ip link del br-pool1; fi
	@sudo kind delete cluster --name calico-ipip-cross-subnet

clean-vxlan-cross-subnet:
	@if sudo clab inspect --all | grep -q 'calico-vxlan-cross-subnet'; then sudo clab destroy -t vxlan-cross-subnet/clab.yaml; fi
	@if ip link show br-pool0 > /dev/null 2>&1; then sudo ip link set br-pool0 down; sudo ip link del br-pool0; fi
	@if ip link show br-pool1 > /dev/null 2>&1; then sudo ip link set br-pool1 down; sudo ip link del br-pool1; fi
	@sudo kind delete cluster --name calico-vxlan-cross-subnet

clean: clean-pcap clean-ipip-cross-subnet clean-vxlan-cross-subnet
	@sudo kind delete cluster --name calico-ipip-default
	@sudo kind delete cluster --name calico-vxlan
	@sudo kind delete cluster --name bgp-full-mesh
