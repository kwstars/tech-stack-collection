FROM nginx:1.25

# 将我们的 nginx.conf 文件复制到容器中
COPY nginx.conf /etc/nginx/conf.d/default.conf

# 更新软件包列表并安装 apache2-utils 用于生成 .htpasswd 文件
RUN apt-get update && apt-get install -y apache2-utils

# 创建一个用户 "user" 和密码 "password" 的 .htpasswd 文件
RUN htpasswd -cb /etc/nginx/.htpasswd user password