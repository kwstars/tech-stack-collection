step1:
ifeq ("$(wildcard .env)","")
	@echo ".env does not exist, downloading..."
	curl -O https://raw.githubusercontent.com/elastic/elasticsearch/8.13/docs/reference/setup/install/docker/.env
else
	@echo ".env exists, skipping download."
endif

step2: step1
	@echo "Starting the cluster..."
	docker-compose up -d

# UI客户端：https://github.com/cars10/elasticvue
es-cluster-check:
	@sudo curl -s -u elastic:elastic --cacert ./certs/ca/ca.crt https://localhost:9200 | jq .

clean:
	@echo "Stopping the cluster..."
	docker-compose rm -sf
	sudo rm -rf certs
