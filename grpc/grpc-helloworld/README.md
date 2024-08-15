
```bash
go install github.com/fullstorydev/grpcurl/cmd/grpcurl@latest
grpcurl -plaintext -d '{"name": "Server1"}' localhost:50051 helloworld.Greeter/SayHello
grpcurl -plaintext -d '{"name": "Server1"}' localhost:50052 helloworld.Greeter/SayHello
grpcurl -plaintext -d '{"name": "Server1"}' localhost:18080 helloworld.Greeter/SayHello
```