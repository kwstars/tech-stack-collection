FROM ubuntu:22.04

RUN apt-get update \
  && apt-get install -y nginx nginx-extras apache2-utils tcpdump tini

VOLUME /media
EXPOSE 80
COPY webdav.conf /etc/nginx/conf.d/default.conf
RUN rm /etc/nginx/sites-enabled/*

# 将我们的 start.sh 文件复制到容器中并设置执行权限
COPY entrypoint.sh /
RUN chmod +x entrypoint.sh

# 使用 tini 作为 init 系统，并运行我们的 start.sh 脚本
ENTRYPOINT ["tini", "--", "/entrypoint.sh"]