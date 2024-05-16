# https://go.dev/doc/install

GO_VESION=1.21.10

install:
	if [ ! -f go$(GO_VESION).linux-amd64.tar.gz ]; then \
		sudo curl -o go$(GO_VESION).linux-amd64.tar.gz https://dl.google.com/go/go$(GO_VESION).linux-amd64.tar.gz; \
		sudo rm -rf /usr/local/go; sudo tar -C /usr/local -xzf go$(GO_VESION).linux-amd64.tar.gz; \
		echo 'export PATH=$$PATH:/usr/local/go/bin' | sudo tee -a ~/.profile; \
		echo 'export GOPATH=~/go' | sudo tee -a ~/.profile; \
		echo 'export GOBIN=$$GOPATH/bin' | sudo tee -a ~/.profile; \
		echo 'export PATH=$$PATH:$$GOROOT/bin:$$GOBIN' | sudo tee -a ~/.profile; \
		echo 'export GO111MODULE=on' | sudo tee -a ~/.profile; \
		echo 'export GOPROXY=https://goproxy.cn' | sudo tee -a ~/.profile; \
		# source ~/.profile ; \
	fi

clean:
	rm -f go$(GO_VESION).linux-amd64.tar.gz
