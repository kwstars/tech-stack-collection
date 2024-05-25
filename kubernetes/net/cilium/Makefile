TARGETS = basics/vxlan-with-kubeproxy \
		basics/native-routing-with-kubeproxy \
		basics/vxlan-without-kubeproxy \
		basics/native-routing-without-kubeproxy \
		basics/vxlan-ebpf-host-routing \
		basics/native-routing-ebpf-host-routing

.PHONY: $(TARGETS) mykindest clean

$(TARGETS):
	bash $@/run.sh
	kubectl apply -f ./test-pod.yaml
	kubectl wait --timeout=100s --for=condition=Ready=true pods --all -A

mykindest:
	docker build -t mykindest/node:v1.28.7 .

clean:
	find . -name "*.pcap" -type f -delete
	$(foreach cluster,$(TARGETS),sudo kind delete cluster --name $(notdir $(cluster));)
