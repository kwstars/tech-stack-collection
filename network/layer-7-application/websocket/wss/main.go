package main

import (
	"crypto/tls"
	"crypto/x509"
	"log"
	"os"

	"ws/handler"

	"github.com/go-kratos/kratos/v2"
	"github.com/go-kratos/kratos/v2/transport/http"
	"github.com/gorilla/mux"
)

func main() {
	// 设置 SSLKEYLOGFILE 环境变量
	os.Setenv("SSLKEYLOGFILE", "keylog.txt")

	router := mux.NewRouter()
	router.HandleFunc("/", handler.WsHandler)

	cert, err := tls.LoadX509KeyPair("./certs/server.pem", "./certs/server-key.pem")
	if err != nil {
		log.Fatalf("failed to load key pair: %s", err)
	}

	caCert, err := os.ReadFile("./certs/ca.pem")
	if err != nil {
		log.Fatalf("failed to read CA certificate: %s", err)
	}

	caCertPool := x509.NewCertPool()
	if !caCertPool.AppendCertsFromPEM(caCert) {
		log.Fatal("failed to append CA certificate")
	}

	tlsConfig := &tls.Config{
		Certificates: []tls.Certificate{cert},
		ClientCAs:    caCertPool,
		ClientAuth:   tls.RequireAndVerifyClientCert,
		KeyLogWriter: createKeyLogWriter(),
	}

	httpSrv := http.NewServer(http.Address(":8080"), http.TLSConfig(tlsConfig))
	httpSrv.HandlePrefix("/", router)

	app := kratos.New(
		kratos.Name("ws"),
		kratos.Server(
			httpSrv,
		),
	)
	if err := app.Run(); err != nil {
		log.Println(err)
	}
}

func createKeyLogWriter() *os.File {
	filename := os.Getenv("SSLKEYLOGFILE")
	if filename == "" {
		return nil
	}
	file, err := os.OpenFile(filename, os.O_WRONLY|os.O_CREATE|os.O_APPEND, 0o600)
	if err != nil {
		log.Fatalf("Failed to create key log file: %v", err)
	}
	return file
}
