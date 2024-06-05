SHELL = /bin/bash

TARGETS = basics/vxlan-with-kubeproxy-default \
		basics/native-routing-with-kubeproxy \
		basics/vxlan-without-kubeproxy \
		basics/native-routing-without-kubeproxy \
		basics/vxlan-ebpf-host-routing \
		basics/native-routing-ebpf-host-routing \
		native-routing-ebpf-host-routing/socket-lb \
		native-routing-ebpf-host-routing/dsr \
		native-routing-ebpf-host-routing/ingress/http \
		native-routing-ebpf-host-routing/ingress/grpc \
		native-routing-ebpf-host-routing/ingress/tls

.PHONY: $(TARGETS) mykindest clean

$(TARGETS):
	bash $@/run.sh $(subst /,-,$@)
	if [ -f $@/validate.sh ]; then \
		chmod +x $@/validate.sh && $@/validate.sh; \
	else \
		kubectl apply -f ./test-pod.yaml; \
		kubectl wait --timeout=100s --for=condition=Ready=true pods --all -A; \
	fi

mykindest:
	docker build -t mykindest/node:v1.28.7 .

clean:
	find . -name "*.pcap" -type f -delete
	$(foreach cluster,$(TARGETS), bash $(cluster)/clean.sh $(subst /,-,$(cluster));)
