package main

import (
	"fmt"
	"net/http"
	"strconv"

	"./websocket"
)

type Message struct {
	Command int `json:command`
	Data int `json:data`
}

func main() {
	port := 8100

	fmt.Println(">> Bloccly Go Server v0.1 <<")
	//fmt.Println(Block.Blue.Block())
	setupRoutes()
	fmt.Printf("[INFO]: Server running on crack and alcohol %+v\n", port)
	http.ListenAndServe(":" + strconv.Itoa(port), nil)
}

func serveWs(pool *websocket.Pool, w http.ResponseWriter, r *http.Request) {
	fmt.Println("[INFO]: WebSocket Endpoint Hit")
	conn, err := websocket.Upgrade(w, r)
	if err != nil {
		fmt.Fprintf(w, "%+v\n", err)
	}

	client := &websocket.Client{
		Conn: conn,
		Pool: pool,
	}

	id := 1

	if len(pool.Clients) == 0 {
		client.ID = 1
	} else {

		exist := true
		for exist {
			exist = false
			for c := range pool.Clients {
				if c.ID == id {
					id++
					exist = true
					break
				}
			}
		}
		client.ID = id
	}

	client.Conn.WriteJSON(Message{
		Command: 0,
		Data:    id,
	})
	pool.Register <- client
	client.Read()
}

func setupRoutes() {
	pool := websocket.NewPool()
	go pool.Start()

	http.HandleFunc("/ws", func(w http.ResponseWriter, r *http.Request) {
		serveWs(pool, w, r)
	})
}
