package handler

import (
	"log"
	"net/http"
	"sync"

	"github.com/google/uuid"
	"github.com/gorilla/websocket"
)

var upgrader = websocket.Upgrader{}

type Client struct {
	ID   string
	Conn *websocket.Conn
}

var (
	clients    = make(map[string]*Client)
	clientsMux sync.RWMutex
)

func WsHandler(w http.ResponseWriter, r *http.Request) {
	c, err := upgrader.Upgrade(w, r, nil)
	if err != nil {
		log.Print("upgrade:", err)
		return
	}
	defer c.Close()

	client := onConnect(c)
	defer onClose(client)

	for {
		mt, message, err := c.ReadMessage()
		if err != nil {
			log.Println("read:", err)
			break
		}
		onMessage(client, mt, message)
	}
}

func onConnect(c *websocket.Conn) *Client {
	clientID := uuid.New().String()
	client := &Client{
		ID:   clientID,
		Conn: c,
	}

	clientsMux.Lock()
	clients[clientID] = client
	clientsMux.Unlock()

	log.Printf("Client connected. ID: %s", clientID)
	return client
}

func onMessage(client *Client, messageType int, message []byte) {
	log.Printf("Received message from client %s: %s", client.ID, message)
	err := client.Conn.WriteMessage(messageType, message)
	if err != nil {
		log.Printf("Error writing to client %s: %v", client.ID, err)
	}
}

func onClose(client *Client) {
	log.Printf("Client disconnected. ID: %s", client.ID)

	clientsMux.Lock()
	delete(clients, client.ID)
	clientsMux.Unlock()
}

// 广播消息给所有客户端
func broadcastMessage(message []byte) {
	clientsMux.RLock()
	defer clientsMux.RUnlock()

	for _, client := range clients {
		err := client.Conn.WriteMessage(websocket.TextMessage, message)
		if err != nil {
			log.Printf("Error broadcasting to client %s: %v", client.ID, err)
		}
	}
}

// 发送消息给特定客户端
func sendToClient(clientID string, message []byte) {
	clientsMux.RLock()
	client, exists := clients[clientID]
	clientsMux.RUnlock()

	if !exists {
		log.Printf("Client %s not found", clientID)
		return
	}

	err := client.Conn.WriteMessage(websocket.TextMessage, message)
	if err != nil {
		log.Printf("Error sending to client %s: %v", clientID, err)
	}
}
