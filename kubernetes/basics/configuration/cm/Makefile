
create-cm-method-1:
	kubectl create -f config-map.yml

create-cm-method-2:
	kubectl create cm random-generator-config \
		--from-literal=PATTERN="Configuration Resource" \
		--from-literal=EXTRA_OPTIONS="high-secure,native" \
		--from-literal=SEED="432576345" \
		--from-file=application.properties

create-pod:
	kubectl apply -f pod.yml

create: create-cm-method-2 create-pod

check:
	kubectl exec -it random-generator -- env
	kubectl exec -it random-generator -- cat /config/app/random-generator.properties

clean:
	kubectl delete --ignore-not-found=true -f config-map.yml
	kubectl delete --ignore-not-found=true svc random-generator
	kubectl delete --ignore-not-found=true pod random-generator
