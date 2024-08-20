FROM golang:1.22 as builder

WORKDIR /app

COPY go.mod go.sum ./
COPY ./app/message/* .
COPY ./api ./api

RUN go build -o server .

FROM ubuntu:22.04

WORKDIR /app
COPY --from=builder /app/server .

CMD ["./server"]
