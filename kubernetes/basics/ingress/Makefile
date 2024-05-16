# https://github.com/kubernetes/ingress-nginx/blob/main/charts/ingress-nginx/values.yaml
ingress-nginx:
	helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
	helm repo update
	helm upgrade --install ingress-nginx ingress-nginx/ingress-nginx \
		--namespace ingress-nginx --create-namespace \
		--version 4.10.1 \
		--set controller.image.registry=registry.lank8s.cn \
		--set defaultBackend.image.registry=registry.lank8s.cn \
		--set controller.admissionWebhooks.patch.image.registry=registry.lank8s.cn

contour:
	kubectl apply -f https://projectcontour.io/quickstart/contour.yaml

prepare:
	@kubectl create deployment be-default --image=gcr.io/kuar-demo/kuard-amd64:blue --replicas=3 --port=8080
	@kubectl expose deployment be-default
	@kubectl create deployment alpaca --image=gcr.io/kuar-demo/kuard-amd64:green --replicas=3 --port=8080
	@kubectl expose deployment alpaca
	@kubectl create deployment bandicoot --image=gcr.io/kuar-demo/kuard-amd64:purple --replicas=3 --port=8080
	@kubectl expose deployment bandicoot
	@kubectl get services -o wide

simple:
	kubectl apply -f simple-ingress.yaml
	kubectl describe ingress simple-ingress

host:
	kubectl apply -f host-ingress.yaml
	kubectl get ingress
	kubectl describe ingress host-ingress

path:
	kubectl apply -f path-ingress.yaml
	kubectl get ingress
	kubectl describe ingress path-ingress

path-rewriting:

tls:


clean:
	kubectl delete ingress host-ingress path-ingress simple-ingress
	kubectl delete service alpaca bandicoot be-default
	kubectl delete deployment alpaca bandicoot be-default
