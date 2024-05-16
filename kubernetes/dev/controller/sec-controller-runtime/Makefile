generator:
	go get k8s.io/code-generator
	go mod tidy
	go mod vendor
	bash hack/update-codegen.sh

verify:
	chmod +x hack/update-codegen.sh
	bash hack/verify-codegen.sh

crd:
	kubectl apply -f ./manifests/crd-with-cols.yaml

create: crd
	kubectl apply -f ./manifests/myres.yaml

.PHONY: ex01
ex01:
	go run ex01-watch/main.go

clean:
	kubectl delete -f ./manifests/myres.yaml
	kubectl delete -f ./manifests/crd-with-cols.yaml
