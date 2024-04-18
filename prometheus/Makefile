.PHONY: run stop remove help install-dashboards

TEXTFILE=/var/lib/node_exporter/textfile_collector

run:
	@docker-compose up -d prometheus node_exporter grafana alertmanager pushgateway consul redis redis_exporter

stop:
	@docker-compose stop

remove:
	@docker-compose rm -sf

ps:
	@docker-compose ps

# 当你看到 "Dashboard not found" 错误时，这可能意味着你正在尝试导入一个包含无效 uid 或 id 的 Dashboard。在这种情况下，你可以尝试删除所有 uid 和 id 字段，然后再次尝试导入该 Dashboard。
grafana-dashboards:
	@bash install_dashboards.sh

grafana-list-dashboards:
	@curl http://admin:admin@localhost:13000/api/search | jq .

grafana-export-demo:
	@curl http://admin:admin@localhost:13000/api/dashboards/uid/bdj05azd10etca > /tmp/demo.json

# 通过首先将输出写入临时文件，然后在输出完全写入后将临时文件重命名为目标文件，可以确保 Prometheus 只在文件完全写入后才读取该文件。这是因为文件重命名操作在 Unix 和 Linux 系统上是原子的，即它会立即完成，不会出现中间状态。
# Atomic Operations in File Systems: 在 Unix 和 Linux 系统中，某些文件系统操作（如重命名）是原子的，即它们在单个操作中立即完成，不会出现中间状态。这意味着，如果一个进程在另一个进程重命名文件的同时尝试读取该文件，它要么会看到重命名操作之前的文件，要么会看到重命名操作之后的文件，但不会看到部分重命名的文件。这是由 POSIX 标准定义的，你可以在这里找到更多信息：POSIX.1-2017
# https://pubs.opengroup.org/onlinepubs/9699919799/functions/rename.html
# https://github.com/prometheus-community/node-exporter-textfile-collector-scripts/blob/master/directory-size.sh
textfile-cronjob:
	@if [ ! -d $(TEXTFILE) ]; then sudo mkdir -p $(TEXTFILE); fi
	@echo "*/5 * * * * root (echo -n 'shadow_entries '; grep -c . /etc/shadow) > $(TEXTFILE)/shadow.prom.$$ && mv $(TEXTFILE)/shadow.prom.$$ $(TEXTFILE)/shadow.prom" | sudo tee /etc/cron.d/shadow_entries
	@sudo chmod 0644 /etc/cron.d/shadow_entries
	@sudo service cron restart

consul-register:
	@curl --request PUT --data @consul_sd_configs.json http://localhost:8500/v1/agent/service/register

consul-deregister:
	@curl --request PUT http://localhost:8500/v1/agent/service/deregister/redis_exporter

consul-services:
	@curl http://localhost:8500/v1/agent/services

clean:
	@sudo rm -f /etc/cron.d/shadow_entries

help:
	@echo "run    - Start the prometheus and node_exporter services."
	@echo "stop   - Stop all services."
	@echo "remove - Remove all stopped containers."
