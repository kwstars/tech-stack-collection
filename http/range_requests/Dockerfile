# 固定具体版本以保证稳定性
FROM node:20-bullseye-slim AS base

# 指定非根路径的工作目录
WORKDIR /usr/src/app

# 只复制安装依赖所需的文件（提高层缓存）
COPY package*.json ./

# [可选] 安装 tcpdump 和 tini
RUN apt-get update && apt-get install -y tcpdump tini

# 定义开发阶段
FROM base as dev

# 使用缓存挂载来加速已存在依赖的安装
# npm install 是一个命令，用于安装 Node.js 项目的所有依赖，包括开发依赖和生产依赖。
RUN --mount=type=cache,target=/usr/src/app/.npm \
  npm set cache /usr/src/app/.npm && \
  npm install

# 复制所有文件
COPY . .

# 开发环境下的启动命令
CMD ["npm", "run", "dev"]

# 定义生产阶段
FROM base as production

# 设定 NODE_ENV 环境变量
ENV NODE_ENV production

# 使用缓存挂载来加速已存在依赖的安装
# npm ci --only=production 用于在持续集成环境中严格按照 `package-lock.json` 文件安装只有生产环境需要的依赖，不包括开发依赖。
RUN --mount=type=cache,target=/usr/src/app/.npm \
  npm set cache /usr/src/app/.npm && \
  npm ci --only=production

# 使用非 root 用户
USER node

# 在安装完依赖之后再复制剩余的源代码
# 再次强调，只复制必要的文件
COPY --chown=node:node . .

# 指明预期的端口
EXPOSE 3000

# 容器启动时运行的命令
CMD [ "node", "express.js" ]