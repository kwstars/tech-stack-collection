FROM golang:1.21 as builder

WORKDIR /app

COPY go.mod go.sum ./
COPY greeter_client/* .

RUN go build -o client .

FROM ubuntu:22.04

RUN apt-get update && apt-get install -y \
  tcpdump \
  net-tools \
  iputils-ping \
  dnsutils \
  curl \
  wget \
  && rm -rf /var/lib/apt/lists/*

WORKDIR /app
COPY --from=builder /app/client .

# CMD ["./client"]

CMD ["sh", "-c", "echo 'Starting client...'; ./client"]