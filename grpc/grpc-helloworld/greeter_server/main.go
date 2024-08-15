package main

import (
	"context"
	"flag"
	"fmt"
	"log"
	"net"
	"os"

	"google.golang.org/grpc"
	pb "google.golang.org/grpc/examples/helloworld/helloworld"
	"google.golang.org/grpc/reflection"
)

var (
	port     = flag.Int("port", 50051, "The server port")
	serverID = flag.String("id", "", "The server ID")
)

// server is used to implement helloworld.GreeterServer.
type server struct {
	pb.UnimplementedGreeterServer
	id string
}

// SayHello implements helloworld.GreeterServer
func (s *server) SayHello(ctx context.Context, in *pb.HelloRequest) (*pb.HelloReply, error) {
	log.Printf("Received: %v", in.GetName())
	return &pb.HelloReply{Message: fmt.Sprintf("Hello %s from server %s", in.GetName(), s.id)}, nil
}

func main() {
	flag.Parse()

	// 优先使用命令行参数，如果没有则使用环境变量
	id := *serverID
	if id == "" {
		id = os.Getenv("SERVER_ID")
	}
	if id == "" {
		log.Fatal("Server ID must be provided either via -id flag or SERVER_ID environment variable")
	}

	lis, err := net.Listen("tcp", fmt.Sprintf(":%d", *port))
	if err != nil {
		log.Fatalf("failed to listen: %v", err)
	}
	s := grpc.NewServer()
	pb.RegisterGreeterServer(s, &server{id: id})
	reflection.Register(s)
	log.Printf("server %s listening at %v", id, lis.Addr())
	if err := s.Serve(lis); err != nil {
		log.Fatalf("failed to serve: %v", err)
	}
}
