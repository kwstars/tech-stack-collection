HOST=http://127.0.0.1:8001

proxy:
	kubectl proxy --port=8001 &

# Creating a resource
create:
	kubectl apply -f ./namespace.yaml
	curl $(HOST)/api/v1/namespaces/project1/pods -H "Content-Type: application/yaml" --data-binary @pod.yaml

# Getting information about a resource
info:
	curl -X GET $(HOST)/api/v1/namespaces/project1/pods/nginx

# Getting the list of resources
list:
	# curl $(HOST)/api/v1/pods
	curl $(HOST)/api/v1/namespaces/project1/pods

# Filtering the result of a list
filtering-label-selector:
	kubectl apply -f ./nginx.yaml
	curl $(HOST)/api/v1/namespaces/default/pods?labelSelector=mylabel
	curl $(HOST)/api/v1/namespaces/default/pods?labelSelector=\!mylabel
	curl $(HOST)/api/v1/namespaces/default/pods?labelSelector=mylabel==foo
	curl $(HOST)/api/v1/namespaces/default/pods?labelSelector=mylabel=foo
	curl $(HOST)/api/v1/namespaces/default/pods?labelSelector=mylabel\!=foo
	curl $(HOST)/api/v1/namespaces/default/pods?labelSelector=mylabel+in+(foo,baz)
	curl $(HOST)/api/v1/namespaces/default/pods?labelSelector=mylabel+notin+(foo,baz)
	curl $(HOST)/api/v1/namespaces/default/pods?labelSelector=mylabel,otherlabel==bar

filtering-field-selector:
	curl $(HOST)/api/v1/namespaces/default/pods?fieldSelector=status.phase==Running
	curl $(HOST)/api/v1/namespaces/default/pods?fieldSelector=status.phase==Running
	curl $(HOST)/api/v1/namespaces/default/pods?fieldSelector=status.phase\!=Running
	curl $(HOST)/api/v1/namespaces/default/pods?fieldSelector=status.phase==Running,spec.restartPolicy\!=Always

# Deleting a resource
delete:
	curl -X DELETE $(HOST)/api/v1/namespaces/project1/pods/nginx


# Deleting a collection of resources
delete-collection:
	curl -X DELETE $(HOST)/api/v1/namespaces/project1/pods

# Updating a resource
update:
	curl $(HOST)/apis/apps/v1/namespaces/project1/deployments  -H "Content-Type: application/yaml" --data-binary @deploy.yaml
	cat deploy.yaml | sed 's/image: nginx/image: nginx:latest/' > deploy2.yaml
	curl -X PUT $(HOST)/apis/apps/v1/namespaces/project1/deployments/nginx -H "Content-Type: application/yaml" --data-binary @deploy2.yaml

# Using a strategic merge patch to update a resource
strategic-merge-patch:
	kubectl apply -f ./deploy.yaml
	curl -X PATCH $(HOST)/apis/apps/v1/namespaces/project1/deployments/nginx -H "Content-Type: application/strategic-merge-patch+json" --data-binary @deploy-patch.json

# Applying resources server-side
apply:
	curl -X PATCH "$(HOST)/apis/apps/v1/namespaces/project1/deployments/nginx?fieldManager=manager1" -H "Content-Type: application/apply-patch+yaml" --data-binary @deploy-server-side.yaml
	curl -X PATCH "$(HOST)/apis/apps/v1/namespaces/project1/deployments/nginx?fieldManager=manager2&force=true" -H "Content-Type: application/apply-patch+yaml" --data-binary @deploy-server-patch1.yaml
	curl -X PATCH "$(HOST)/apis/apps/v1/namespaces/project1/deployments/nginx?fieldManager=manager1" -H "Content-Type: application/apply-patch+yaml" --data-binary @deploy-server-patch2.yaml

# Paginating results
paginating:
	curl "$(HOST)/api/v1/pods?limit=1"
	curl "$(HOST)/api/v1/pods?limit=1&continue=<continue_token_1>"

# Getting result as table
table:
	curl $(HOST)/api/v1/pods -H 'Accept: application/json;as=Table;g=meta.k8s.io;v=v1'
	curl $(HOST)/api/v1/pods?includeObject=None -H 'Accept: application/json;as=Table;g=meta.k8s.io;v=v1'

# Using the YAML format
yaml:
	curl $(HOST)/api/v1/pods -H 'Accept: application/yaml'
	curl $(HOST)/api/v1/namespaces/default/pods -H "Content-Type: application/yaml" -H 'Accept: application/yaml' --data-binary @pod.yaml
