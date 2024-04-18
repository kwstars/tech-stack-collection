.PHONY: run stop remove help install-dashboards

TEXTFILE=/var/lib/node_exporter/textfile_collector

run:
	@docker-compose up -d

stop:
	@docker-compose stop

remove:
	@docker-compose rm -sf

ps:
	@docker-compose ps

install-grafana-dashboards:
	@bash install_dashboards.sh

# 通过首先将输出写入临时文件，然后在输出完全写入后将临时文件重命名为目标文件，可以确保 Prometheus 只在文件完全写入后才读取该文件。这是因为文件重命名操作在 Unix 和 Linux 系统上是原子的，即它会立即完成，不会出现中间状态。
# Atomic Operations in File Systems: 在 Unix 和 Linux 系统中，某些文件系统操作（如重命名）是原子的，即它们在单个操作中立即完成，不会出现中间状态。这意味着，如果一个进程在另一个进程重命名文件的同时尝试读取该文件，它要么会看到重命名操作之前的文件，要么会看到重命名操作之后的文件，但不会看到部分重命名的文件。这是由 POSIX 标准定义的，你可以在这里找到更多信息：POSIX.1-2017
# https://pubs.opengroup.org/onlinepubs/9699919799/functions/rename.html
# https://github.com/prometheus-community/node-exporter-textfile-collector-scripts/blob/master/directory-size.sh
install-textfile-cronjob:
	@if [ ! -d $(TEXTFILE) ]; then sudo mkdir -p $(TEXTFILE); fi
	@echo "*/5 * * * * root (echo -n 'shadow_entries '; grep -c . /etc/shadow) > $(TEXTFILE)/shadow.prom.$$ && mv $(TEXTFILE)/shadow.prom.$$ $(TEXTFILE)/shadow.prom" | sudo tee /etc/cron.d/shadow_entries
	@sudo chmod 0644 /etc/cron.d/shadow_entries
	@sudo service cron restart

clean:
	@rm -f /etc/cron.d/shadow_entries

help:
	@echo "run    - Start the prometheus and node_exporter services."
	@echo "stop   - Stop all services."
	@echo "remove - Remove all stopped containers."
