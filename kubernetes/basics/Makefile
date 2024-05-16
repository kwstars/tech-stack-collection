create:
	kind create cluster --image=mykindest/node:v1.28.7 --config=./kind.yaml

list:
	@sudo kind get clusters

clean:
	kind delete cluster --name kind

load-image:
	kind load docker-image nigelpoulton/k8sbook:shield-ingress --name=kind

nodes:
	kubectl get nodes -o wide
