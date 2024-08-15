package main

import (
	"context"
	"flag"
	"log"
	"time"

	"google.golang.org/grpc"
	"google.golang.org/grpc/credentials/insecure"
	pb "google.golang.org/grpc/examples/helloworld/helloworld"
)

const (
	defaultName = "world"
)

var (
	addr = flag.String("addr", "nginx:8080", "the address to connect to")
	name = flag.String("name", defaultName, "Name to greet")
)

func main() {
	flag.Parse()
	// Set up a connection to the server.
	conn, err := grpc.NewClient(*addr, grpc.WithTransportCredentials(insecure.NewCredentials()),
		grpc.WithDefaultCallOptions(grpc.MaxCallRecvMsgSize(16*1024*1024)), // 16MB
		grpc.WithDefaultCallOptions(grpc.MaxCallSendMsgSize(16*1024*1024)), // 16MB
	)
	if err != nil {
		log.Fatalf("did not connect: %v", err)
	}
	defer conn.Close()
	c := pb.NewGreeterClient(conn)

	for {
		r, err := c.SayHello(context.TODO(), &pb.HelloRequest{Name: *name})
		if err != nil {
			log.Printf("could not greet: %v\n", err)
		}
		log.Printf("Greeting: %s", r.GetMessage())

		// Sleep for one second before sending the next message.
		time.Sleep(time.Second)
	}
}
