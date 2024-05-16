# https://book.kubebuilder.io/quick-start
install:
	curl -L -o kubebuilder "https://go.kubebuilder.io/dl/latest/$(go env GOOS)/$(go env GOARCH)"
	chmod +x kubebuilder && sudo mv kubebuilder /usr/local/bin/

create:
	mkdir demo; cd demo; kubebuilder init --domain linux88.com --repo github.com/kwstars/kubebuilder-demo
