package websocket

import (
	"fmt"
	"github.com/gorilla/websocket"
	"log"
)

type Client struct {
	ID   int
	Conn *websocket.Conn
	Pool *Pool
}

type Message struct {
	Type int
	Body string
}

type NewBlockMessage struct {
	Blocktype int `json:int`
}

func (c *Client) Read() {
	defer func() {
		c.Pool.Unregister <- c
		c.Conn.Close()
	}()

	for {
		messageType, p, err := c.Conn.ReadMessage()
		if err != nil {
			log.Println(err)
			return
		}

		message := Message{Type: messageType, Body: string(p)}
		fmt.Printf("[INFO] Message Received: %+v\n", message)
		c.Pool.Broadcast <- message
	}
}
