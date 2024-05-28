SHELL := /bin/bash

.PHONY: clab

TARGETS = clab

$(TARGETS):
	bash $@/run.sh

clean: clean-clab
	@find . -name "*.pcap" -type f -delete

clean-clab:
	@if sudo clab inspect --all | grep -q 'wireguard'; then sudo clab destroy -t clab/clab.yaml; fi
	@rm -f clab/{gw1_private,gw1_public,gw2_private,gw2_public,clab.yaml}
