.PHONY: clab manual

TARGETS = clab manual

$(TARGETS):
	bash $@/run.sh

clean: clean-clab clean-manual
	@find . -name "*.pcap" -type f -delete

clean-clab:
	@if sudo clab inspect --all | grep -q 'bridge'; then sudo clab destroy -t clab/clab.yaml; fi
	@if ip link show br0 > /dev/null 2>&1; then sudo ip link set br0 down; sudo ip link del br0; fi

clean-manual:
	bash ./manual/clean.sh
