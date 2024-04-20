VERSION = v0.13.0

# 下载 kube-prometheus 并切换到对应 tag 的版本
prepare:
	if [ ! -d kube-prometheus ]; then git clone https://github.com/prometheus-operator/kube-prometheus.git; fi
	cd kube-prometheus && git checkout $(VERSION);

# 安装 kube-prometheus 的 CRD
# https://github.com/prometheus-operator/prometheus-operator/issues/5104
step1:
	kubectl create -f kube-prometheus/manifests/setup

# 验证 step1
step1-check:
	kubectl get crds | grep coreos

# 安装 kube-prometheus 的组件
# 网络问题：配置代理 或 修改镜像地址
# 修改副本数: replicas:
# 报警: KubeSchedulerDown, KubeControllerManagerDown, CPUThrottlingHigh(调整资源)
step2:
	kubectl apply -f kube-prometheus/manifests/

# 【可选】 修改副本数
step3:
	kubectl patch prometheus k8s -n monitoring --type='json' -p='[{"op": "replace", "path": "/spec/replicas", "value":1}]'
	kubectl patch alertmanager main -n monitoring --type='json' -p='[{"op": "replace", "path": "/spec/replicas", "value":1}]'
	kubectl patch svc alertmanager-main -n monitoring -p '{"spec": {"type": "NodePort"}}'
	kubectl patch svc grafana -n monitoring -p '{"spec": {"type": "NodePort"}}'
	kubectl patch svc prometheus-k8s -n monitoring -p '{"spec": {"type": "NodePort"}}'

clean:
	@rm -rf kube-prometheus
