package main

import (
	"crypto/tls"
	"crypto/x509"
	"flag"
	"log"
	"net/url"
	"os"
	"os/signal"
	"time"

	"github.com/gorilla/websocket"
)

var addr = flag.String("addr", "localhost:8080", "http service address")

func main() {
	flag.Parse()
	log.SetFlags(0)

	// 设置 SSLKEYLOGFILE 环境变量
	os.Setenv("SSLKEYLOGFILE", "../keylog.txt")

	interrupt := make(chan os.Signal, 1)
	signal.Notify(interrupt, os.Interrupt)

	// 加载客户端证书
	cert, err := tls.LoadX509KeyPair("../certs/client.pem", "../certs/client-key.pem")
	if err != nil {
		log.Fatal("LoadX509KeyPair:", err)
	}

	// 加载 CA 证书
	caCert, err := os.ReadFile("../certs/ca.pem")
	if err != nil {
		log.Fatal("Reading CA certificate:", err)
	}
	caCertPool := x509.NewCertPool()
	caCertPool.AppendCertsFromPEM(caCert)

	// 创建 TLS 配置
	tlsConfig := &tls.Config{
		Certificates: []tls.Certificate{cert},
		RootCAs:      caCertPool,
		KeyLogWriter: createKeyLogWriter(),
	}

	// 创建自定义的 Dialer
	dialer := websocket.Dialer{
		TLSClientConfig: tlsConfig,
	}

	u := url.URL{Scheme: "wss", Host: *addr, Path: "/"}
	log.Printf("connecting to %s", u.String())

	c, _, err := dialer.Dial(u.String(), nil)
	if err != nil {
		log.Fatal("dial:", err)
	}
	defer c.Close()

	done := make(chan struct{})

	go func() {
		defer close(done)
		for {
			_, message, err := c.ReadMessage()
			if err != nil {
				log.Println("read:", err)
				return
			}
			log.Printf("recv: %s", message)
		}
	}()

	ticker := time.NewTicker(time.Second)
	defer ticker.Stop()

	for {
		select {
		case <-done:
			return
		case t := <-ticker.C:
			err := c.WriteMessage(websocket.TextMessage, []byte(t.String()))
			if err != nil {
				log.Println("write:", err)
				return
			}
		case <-interrupt:
			log.Println("interrupt")

			// Cleanly close the connection by sending a close message and then
			// waiting (with timeout) for the server to close the connection.
			err := c.WriteMessage(websocket.CloseMessage, websocket.FormatCloseMessage(websocket.CloseNormalClosure, ""))
			if err != nil {
				log.Println("write close:", err)
				return
			}
			select {
			case <-done:
			case <-time.After(time.Second):
			}
			return
		}
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
