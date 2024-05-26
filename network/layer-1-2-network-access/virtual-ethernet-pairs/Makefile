.PHONY: clab manual

TARGETS = clab manual

$(TARGETS):
	bash $@/run.sh

clean: clean-clab clean-manual
	@find . -name "*.pcap" -type f -delete

clean-clab:
	@if sudo clab inspect --all | grep -q 'veth'; then sudo clab destroy -t clab/clab.yaml; fi

clean-manual:
	bash ./manual/clean.sh
