.PHONY: udp vxlan-default vxlan-directrouting

TARGETS = udp vxlan-default vxlan-directrouting

$(TARGETS):
	bash $@/kind.sh

mykindest:
	docker build -t mykindest/node:v1.28.7 .

list:
	@sudo kind get clusters

clean-pcap:
	find . -name "*.pcap" -type f -delete

clean-flannel-vxlan-directrouting:
	@if sudo clab inspect --all | grep -q 'flannel-vxlan-directrouting'; then sudo clab destroy -t vxlan-directrouting/clab.yaml; fi
	@if ip link show br-pool0 > /dev/null 2>&1; then sudo ip link set br-pool0 down; sudo ip link del br-pool0; fi
	@if ip link show br-pool1 > /dev/null 2>&1; then sudo ip link set br-pool1 down; sudo ip link del br-pool1; fi
	@sudo kind delete cluster --name flannel-vxlan-directrouting

clean: clean-pcap clean-flannel-vxlan-directrouting
	@sudo kind delete cluster --name flannel-udp
	@sudo kind delete cluster --name flannel-vxlan-default
