.PHONY: clab

TARGETS = clab

$(TARGETS):
	bash $@/run.sh

clean:
	if sudo clab inspect --all | grep -q 'ipip'; then sudo clab destroy -t clab/clab.yaml; fi
	find . -name "*.pcap" -type f -delete
