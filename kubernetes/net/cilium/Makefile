TARGETS = basics/vxlan-with-kubeproxy-default \
		basics/native-routing-with-kubeproxy \
		basics/vxlan-without-kubeproxy \
		basics/native-routing-without-kubeproxy \
		basics/vxlan-ebpf-host-routing \
		basics/native-routing-ebpf-host-routing \
		native-routing-ebpf-host-routing/socket-lb \
		native-routing-ebpf-host-routing/dsr \
		native-routing-ebpf-host-routing/ingress

.PHONY: $(TARGETS) mykindest clean

$(TARGETS):
	bash $@/run.sh
	[ -f $@/validate.sh ] && chmod +x $@/validate.sh && $@/validate.sh || kubectl apply -f ./test-pod.yaml
	kubectl wait --timeout=100s --for=condition=Ready=true pods --all -A

mykindest:
	docker build -t mykindest/node:v1.28.7 .

clean:
	find . -name "*.pcap" -type f -delete
	$(foreach cluster,$(TARGETS),sudo kind delete cluster --name $(notdir $(cluster));)
