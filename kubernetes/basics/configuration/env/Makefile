create: create-cm create-secret
	kubectl apply -f pod.yml

create-cm:
	kubectl create configmap random-generator-config \
			--from-literal=PATTERN=EnvVarConfiguration \
			--from-literal="ILLEG.AL=Invalid Envvar name"

create-secret:
	kubectl create secret generic random-generator-secret --from-literal=seed=11232156346

check:
	kubectl exec -it random-generator -- env

clean:
	kubectl delete --ignore-not-found=true -f pod.yml
	kubectl delete --ignore-not-found=true cm random-generator-config
	kubectl delete --ignore-not-found=true secret random-generator-secret
