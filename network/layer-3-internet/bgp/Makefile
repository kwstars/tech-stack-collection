TARGETS = lab01-bgp-med-prepend

.PHONY: $(TARGETS) mykindest clean

$(TARGETS):
	bash $@/run.sh $(subst /,-,$@)

mykindest:
	docker build -t mykindest/node:v1.28.7 .

clean:
	find . -name "*.pcap" -type f -delete
	$(foreach cluster,$(TARGETS),bash $(cluster)/clean.sh $(subst /,-,$(cluster));)
