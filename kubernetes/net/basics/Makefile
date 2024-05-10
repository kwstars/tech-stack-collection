.PHONY: ipsec vxlan ipip host-gw gre wireguard

TARGETS = ipsec vxlan ipip host-gw gre wireguard

change-vbox-path:
	@read -p "Enter virtualbox path: " path; \
	current_path=$$(VBoxManage list systemproperties | grep "Default machine folder" | cut -d ':' -f 2 | xargs); \
	if [ ! -d $$path ]; then sudo mkdir -p $$path; sudo chown $(shell id -un):$(shell id -un) $$path; fi; \
	if [ "$$current_path" != "$$path" ]; then \
		VBoxManage setproperty machinefolder $$path; \
		sudo systemctl restart virtualbox; \
	fi
	VBoxManage list systemproperties | grep "Default machine folder"

up:
	vagrant up
	vagrant reload

ssh:
	vagrant ssh

status:
	vagrant status

destroy:
	vagrant destroy

.PHONY: bridge
bridge:
	if ! ip link show br0 > /dev/null 2>&1; then sudo ip link add name br0 type bridge; sudo ip link set br0 up; fi
	sudo clab deploy -t bridge/clab.yaml
	ip link show type bridge
	bridge link show dev eth1
	docker exec -it clab-bridge-server1 ip link show eth1
	brctl showmacs br0

.PHONY: routing
routing:
	@sudo clab deploy -t routing/clab.yaml

.PHONY: veth-pairs
veth-pairs:
	@sudo clab deploy -t veth-pairs/clab.yaml

veth-pairs-manual:
	@sudo chmod +x veth-pairs-manual.sh
	bash veth-pairs-manual.sh

$(TARGETS):
	@sudo clab deploy -t $@/clab.yaml
	docker exec -d clab-$@-gw1 bash -c 'tcpdump -pen -i eth2 -w /data/gw1-eth2.pcap'
	docker exec -d clab-$@-gw2 bash -c 'tcpdump -pen -i eth2 -w /data/gw2-eth2.pcap'
	docker exec -d clab-$@-server1 bash -c 'curl 10.1.8.10'
	docker exec -d clab-$@-server2 bash -c 'curl 10.1.5.10'

clean-bridge:
	@if sudo clab inspect --all | grep -q 'bridge'; then sudo clab destroy -t bridge/clab.yaml; fi
	@if ip link show br0 > /dev/null 2>&1; then sudo ip link set br0 down; sudo ip link del br0; fi

clean-routing:
	@if sudo clab inspect --all | grep -q 'routing'; then sudo clab destroy -t routing/clab.yaml; fi

clean-veth-pairs:
	@if sudo clab inspect --all | grep -q 'veth-pair'; then sudo clab destroy -t veth-pairs/clab.yaml; fi
	@if sudo ip netns list | grep -q 'ns1'; then sudo ip netns del ns1; fi
	@if sudo ip netns list | grep -q 'ns2'; then sudo ip netns del ns2; fi

clean-%:
	@echo "Cleaning $*"
	@if sudo clab inspect --all | grep -q '$*'; then sudo clab destroy -t $*/clab.yaml; fi

clean: $(addprefix clean-, $(TARGETS)) clean-bridge clean-routing clean-veth-pairs
	find . -name "*.pcap" -type f -delete
