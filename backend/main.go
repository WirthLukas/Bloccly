package main

import (
	Model "./models"
	"./websocket"
	"fmt"
	"net/http"
	"strconv"
)


func main() {
	port := 8100

	fmt.Println("Connect to DB ...\n\r")
	repo := data.ConnectToDb()
	fmt.Println("Trying to write string on DB")
	data.WriteToDb(repo, 1, 200)
	data.ReadScores(repo)

	fmt.Println(">> Bloccly Go Server v1.0 <<")
	setupRoutes()
	fmt.Printf("[INFO]: Server running on port %+v.\n", port)
	_ = http.ListenAndServe(":"+strconv.Itoa(port), nil)
}

func serveWs(pool *websocket.Pool, w http.ResponseWriter, r *http.Request) {
	fmt.Println("[INFO]: WebSocket Endpoint Hit")
	conn, err := websocket.Upgrade(w, r)
	if err != nil {
		_, _ = fmt.Fprintf(w, "%+v\n", err)
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

	_ = client.Conn.WriteJSON(Model.CommandDto{
		Command:  0,
		PlayerId: id,
		Data:     strconv.Itoa(id),
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
