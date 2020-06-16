package websocket

import (
	"fmt"
	"strconv"

	Model "../models"
)

type Pool struct {
	Register   chan *Client
	Unregister chan *Client
	Clients    map[*Client]bool
	Broadcast  chan Model.CommandDto
}

func NewPool() *Pool {
	return &Pool{
		Register:   make(chan *Client),
		Unregister: make(chan *Client),
		Clients:    make(map[*Client]bool),
		Broadcast:  make(chan Model.CommandDto),
	}
}


func (pool *Pool) Start() {
	for {
		select {
		case client := <-pool.Register:
			pool.Clients[client] = true
			fmt.Printf("[INFO]: A new challenger (%+v) has appeared \n", client.ID)
			fmt.Println("[INFO]: Size of Connection Pool: ", len(pool.Clients))
			for c := range pool.Clients {
				if c.ID != client.ID {
					_ =  c.Conn.WriteJSON(Model.CommandDto{
						Command:  Model.NewPlayer.CommandToInt(),
						PlayerId: client.ID,
						Data:     strconv.Itoa(client.ID),
					})

					_ =  client.Conn.WriteJSON(Model.CommandDto{
						Command:  Model.NewPlayer.CommandToInt(),
						PlayerId: c.ID,
						Data:     strconv.Itoa(c.ID),
					})
				}
			}

			break
		case client := <-pool.Unregister:
			delete(pool.Clients, client)
			fmt.Println("[INFO]: Size of Connection Pool: ", len(pool.Clients))
			//for client, _ := range pool.Clients {
			//	client.Conn.WriteJSON(Message{})
			//}
			break
		case message := <-pool.Broadcast:
			fmt.Println("[INFO]: Broadcasting message to all active clients")
			for client := range pool.Clients {
				if err := client.Conn.WriteJSON(message); err != nil {
					fmt.Println(err)
					return
				}
				//if err := client.Conn.WriteMessage(message.Type, message.Body); err != nil {
				//	fmt.Println(err)
				//	return
				//}
			}
		}
	}
}
