FROM node:20-alpine AS builder

WORKDIR /app

# 复制依赖文件
COPY package.json package-lock.json ./

# 安装依赖 (如果你在国内服务器构建，可以取消下面这行的注释使用淘宝源)
# RUN npm config set registry https://registry.npmmirror.com
RUN npm install

# 复制源码并进行构建
COPY . .
RUN npm run build

# 第二阶段：生产环境 (Nginx)
FROM nginx:alpine

# 将构建好的文件从第一阶段复制到 Nginx 目录
COPY --from=builder /app/dist /usr/share/nginx/html

# 复制自定义 Nginx 配置 (下一步创建)
COPY nginx.conf /etc/nginx/conf.d/default.conf

# 暴露端口
EXPOSE 80

# 启动 Nginx
CMD ["nginx", "-g", "daemon off;"]
