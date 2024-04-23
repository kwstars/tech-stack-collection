test-cmd:
	docker build -f cmd/Dockerfile -t ubuntu-sleeper .
	if [ $$(docker ps -a -f name=test-cmd -q) ]; then docker rm -f $@; fi
	docker run --name $@ ubuntu-sleeper

test-entrypoint-with-no-args:
	docker build -f entrypoint/Dockerfile -t ubuntu-sleeper .
	if [ $$(docker ps -a -f name=test-entrypoint -q) ]; then docker rm -f test-entrypoint; fi
	docker run --name test-entrypoint ubuntu-sleeper

test-entrypoint-with-args:
	docker build -f entrypoint/Dockerfile -t ubuntu-sleeper .
	if [ $$(docker ps -a -f name=test-entrypoint -q) ]; then docker rm -f test-entrypoint; fi
	# docker run --entrypoint sleep2.0 ubuntu-sleeper 10
	docker run --name test-entrypoint ubuntu-sleeper 10
