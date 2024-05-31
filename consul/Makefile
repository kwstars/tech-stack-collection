TARGETS =  \
	deployments/vm \
	deployments/k8s \

.PHONY: $(TARGETS) clean

$(TARGETS):
	bash $@/run.sh consul-$(subst /,-,$@)

clean:
	bash deployments/k8s/clean.sh consul-deployments-k8s
