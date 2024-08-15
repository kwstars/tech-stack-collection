FROM golang:1.21 as builder

WORKDIR /app

COPY go.mod go.sum ./
COPY ./greeter_server/* .

RUN go build -o server .

FROM ubuntu:22.04

RUN apt-get update && apt-get install -y tcpdump net-tools && rm -rf /var/lib/apt/lists/*

WORKDIR /app
COPY --from=builder /app/server .

CMD ["./server"]