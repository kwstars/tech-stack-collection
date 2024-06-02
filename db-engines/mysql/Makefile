TARGETS =  \
	deployments/standalone \
	deployments/master-master \
	deployments/master-slave \


.PHONY: $(TARGETS) clean

$(TARGETS):
	bash $@/run.sh $(subst /,-,$@)

clean:
	bash deployments/standalone/clean.sh
	bash deployments/master-master/clean.sh
	bash deployments/master-slave/clean.sh
