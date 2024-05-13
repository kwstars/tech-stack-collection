.PHONY: non-ha-cluster clean non-ha-multi-cluster

non-ha-cluster:
	make -C deployments/non-ha-cluster run

non-ha-multi-cluster:
	make -C deployments/non-ha-multi-cluster run

# UserName: admin
password:
	@kubectl get secrets argocd-initial-admin-secret -n argocd -o jsonpath="{.data.password}" | base64 -d

dir:
	kubectl -n argocd apply -f deploy-manifests/app/directory/directory.yaml

helm:
	kubectl apply -f deploy-manifests/app/helm/helm.yaml

app-of-apps:
	argocd login argocd.linux88.com:443 --username admin --password $(shell make password)
	argocd app create apps --dest-namespace argocd --dest-server https://kubernetes.default.svc --repo https://github.com/argoproj/argocd-example-apps.git --path apps
	argocd app sync apps

clean:
	make -C deployments/non-ha-cluster clean
	make -C deployments/non-ha-multi-cluster clean
