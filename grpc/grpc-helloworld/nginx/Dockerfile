FROM nginx:1.27

RUN apt-get update && apt-get install -y tcpdump && rm -rf /var/lib/apt/lists/*

COPY ./nginx/grpc_proxy.conf /etc/nginx/conf.d/grpc_proxy.conf