CHART_NAME=initchart

# 创建 Helm chart
create:
	helm create $(CHART_NAME)

# 打包 Helm chart
package:
	helm package $(CHART_NAME)

# 对 Helm chart 进行语法检查
lint:
	helm lint $(CHART_NAME)

# 在不实际执行的情况下运行 Helm install 命令，以便调试
# https://helm.sh/docs/chart_template_guide/debugging/
debug:
	helm install --generate-name --dry-run --debug $(CHART_NAME)

clean:
	rm -rf $(CHART_NAME) $(CHART_NAME)-*.tgz
