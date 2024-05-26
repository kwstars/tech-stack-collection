.PHONY: clab manual

TARGETS = clab manual

$(TARGETS):
	bash $@/run.sh

clean: clean-clab
	@find . -name "*.pcap" -type f -delete

clean-clab:
	@if sudo clab inspect --all | grep -q 'host-gw'; then sudo clab destroy -t clab/clab.yaml; fi

# clean-manual:
# 	bash ./manual/clean.sh
