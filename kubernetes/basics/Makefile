create:
	kind create cluster --image=kindest/node:v1.28.7 --config=./kind.yaml

list:
	@sudo kind get clusters

clean:
	kind delete cluster --name kind

load-image:
	kind load docker-image k8spatterns/random-generator:1.0 --name=kind

nodes:
	kubectl get nodes -o wide
