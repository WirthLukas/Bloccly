package websocket

import (
	"fmt"
	"github.com/gorilla/websocket"
	"log"
	"strconv"

	"../data"
	Model "../models"
)

type Client struct {
	ID   int
	Conn *websocket.Conn
	Pool *Pool
}

type Message struct {
	Type int
	Body []byte
}

func (c *Client) Read() {
	defer func() {
		c.Pool.Unregister <- c
		err := c.Conn.Close()
		if err != nil {
			log.Println("[INFO]: Client unregistered ", err)
		}
	}()

	for {
		messageType, p, err := c.Conn.ReadMessage()
		if err != nil {
			log.Println(err)
			return
		}

		message := Message{Type: messageType, Body: p}
		fmt.Printf("[INFO]: Message Received. JSON contains: %+v\n", string(message.Body))
		clientCommand := Model.ParseJSON(message.Body)
		fmt.Printf("[INFO]: Command received from Player %+v. Command is %+v. Data contains << %+v >>.\n",
			clientCommand.PlayerId,
			Model.Command(clientCommand.Command).CommandToString(),
			clientCommand.Data)

		if clientCommand.Command == Model.Loss.CommandToInt() {
			repo := data.ConnectToDb()
			points, err := strconv.Atoi(clientCommand.Data)

			if err == nil {
				data.WriteToDb(repo, clientCommand.PlayerId, points)
			}
		} else if clientCommand.Command == Model.BlockUpdate.CommandToInt() {
			c.Pool.Broadcast <- *clientCommand
		}
	}
}
