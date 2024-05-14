crd:
	kubectl apply -f crd-with-cols.yaml

check:
	curl http://localhost:8001/apis/mygroup.example.com/v1alpha1/myresources
	curl http://localhost:8001/apis/mygroup.example.com/v1alpha1/namespaces/default/myresources
	kubectl get crd -A

get:
	kubectl get myresources

create: crd
	kubectl apply -f myres.yaml

clean:
	kubectl delete -f myres.yaml
	kubectl delete -f crd-with-cols.yaml
