FROM nginx:stable-bullseye

# [可选] 安装 tcpdump 和 tini
# RUN apt-get update && apt-get install -y --no-install-recommends apt-utils gnupg2 && \
#   apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3B4FE6ACC0B21F32 && \
RUN sed -i 's|http://archive.ubuntu.com/ubuntu/|https://mirrors.tuna.tsinghua.edu.cn/ubuntu/|g' /etc/apt/sources.list && \
  apt-get update && apt-get install -y tcpdump tini

# 将 nginx.conf 文件复制到容器中
COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY nginx.crt /etc/nginx/ssl/nginx.crt
COPY nginx.key /etc/nginx/ssl/nginx.key
COPY dhparam.pem /etc/nginx/ssl/dhparam.pem
COPY ca.crt /etc/nginx/ssl/ca.crt

# 创建一个简单的 index.html 文件
# RUN echo "Hello, This is for https!" > /usr/share/nginx/html/index.html

# 将我们的 start.sh 文件复制到容器中并设置执行权限
COPY start.sh /start.sh
RUN chmod +x /start.sh

# 使用 tini 作为 init 系统，并运行我们的 start.sh 脚本
ENTRYPOINT ["tini", "--", "/start.sh"]
