# 使用官方 Node.js 14 镜像作为基础镜像
FROM node:20-bullseye-slim

# 设置工作目录
WORKDIR /usr/src/app

# 将 package.json 和 package-lock.json 文件复制到工作目录
COPY package*.json ./

# 安装依赖
RUN npm install

# 安装 tcpdump
RUN apt-get update && apt-get install -y tcpdump tini

# 其他 Dockerfile 指令...
# 将应用的源代码复制到工作目录
COPY . .

# 暴露 3000 端口
EXPOSE 3000

# 定义 Docker 容器启动时运行的命令
CMD [ "node", "express.js" ]