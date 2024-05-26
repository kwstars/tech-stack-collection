.PHONY: clab

TARGETS = clab

$(TARGETS):
	bash $@/run.sh

clean: clean-clab
	@find . -name "*.pcap" -type f -delete

clean-clab:
	@if sudo clab inspect --all | grep -q 'routing'; then sudo clab destroy -t clab/clab.yaml; fi
