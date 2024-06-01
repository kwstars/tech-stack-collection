TARGETS =  \
	deployments/standalone \
	deployments/master-slave \
	deployments/sentinel \
	deployments/cluster \
	ds/string \
	ds/hash \
	ds/list \
	ds/set \
	ds/sorted-set \
	ds/stream \
	ds/geo \
	ds/bitmap	\
	ds/bitfield \
	ds/hyperloglog \

.PHONY: $(TARGETS) clean

$(TARGETS):
	bash $@/run.sh $(subst /,-,$@)

clean:
	bash deployments/standalone/clean.sh
	bash deployments/master-slave/clean.sh
	bash deployments/sentinel/clean.sh
	bash deployments/cluster/clean.sh
