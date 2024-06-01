TARGETS =  \
	ingress/nginx/auth/basic \
	ingress/nginx/https \

.PHONY: $(TARGETS) clean

$(TARGETS):
	bash $@/run.sh k8s-basic-$(subst /,-,$@)

clean:
	$(foreach cluster,$(TARGETS), bash $(cluster)/clean.sh k8s-basic-$(subst /,-,$(cluster));)
