package websocket

import "fmt"

type Pool struct {
	Register   chan *Client
	Unregister chan *Client
	Clients    map[*Client]bool
	Broadcast  chan Message
}

func NewPool() *Pool {
	return &Pool{
		Register:   make(chan *Client),
		Unregister: make(chan *Client),
		Clients:    make(map[*Client]bool),
		Broadcast:  make(chan Message),
	}
}


func (pool *Pool) Start() {
	//TODO: Change messages
	for {
		select {
		case client := <-pool.Register:
			pool.Clients[client] = true
			fmt.Println("[INFO]: Size of Connection Pool: ", len(pool.Clients))
			for client, _ := range pool.Clients {
				fmt.Printf("[INFO]: A new challenger (%+v) has appeared \n", client.ID)
				//client.Conn.WriteJSON(Message{})
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
			for client, _ := range pool.Clients {
				//if err := client.Conn.WriteJSON(message); err != nil {
				//	fmt.Println(err)
				//	return
				//}
				if err := client.Conn.WriteMessage(message.Type, []byte(message.Body)); err != nil {
					fmt.Println(err)
					return
				}
			}
		}
	}
}
