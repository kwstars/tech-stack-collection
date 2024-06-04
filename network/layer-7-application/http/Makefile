TARGETS =  \
		2/h2c \
		2/h2 \
		https \

.PHONY: $(TARGETS) clean

$(TARGETS):
	bash $@/run.sh $(subst /,-,$@)

clean:
	find . -name "*.pcap" -type f -delete
	$(foreach cluster,$(TARGETS), bash $(cluster)/clean.sh $(subst /,-,$(cluster));)
