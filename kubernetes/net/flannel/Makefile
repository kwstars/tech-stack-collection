TARGETS = udp \
					vxlan/default \
					vxlan/direct-routing \
					ipip \
					host-gw \
					ipsec \
					wireguard

.PHONY: $(TARGETS) mykindest clean

$(TARGETS):
	bash $@/run.sh $(subst /,-,$@)
	if [ -f $@/validate.sh ]; then \
		chmod +x $@/validate.sh && $@/validate.sh; \
	else \
		kubectl apply -f ./test-pod.yaml; \
	fi
	kubectl wait --timeout=100s --for=condition=Ready=true pods --all -A

mykindest:
	docker build -t mykindest/node:v1.28.7 .

clean-vxlan-direct-routing:
	@if sudo clab inspect --all | grep -q 'direct-routing'; then sudo clab destroy -t vxlan/direct-routing/clab.yaml; fi
	@if ip link show br-pool0 > /dev/null 2>&1; then sudo ip link set br-pool0 down; sudo ip link del br-pool0; fi
	@if ip link show br-pool1 > /dev/null 2>&1; then sudo ip link set br-pool1 down; sudo ip link del br-pool1; fi

clean: clean-vxlan-direct-routing
	find . -name "*.pcap" -type f -delete
	$(foreach cluster,$(TARGETS),sudo kind delete cluster --name $(subst /,-,$(cluster));)
