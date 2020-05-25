package service

import (
	"fmt"
	"github.com/gorilla/websocket"
	"log"
	"net/http"
)

var upgrader = websocket.Upgrader{
	ReadBufferSize:  2048,
	WriteBufferSize: 2048,
	CheckOrigin: func(r *http.Request) bool {
		return true
	},
}

type WebSocket struct {
	Conn   *websocket.Conn
	Out    chan []byte
	In     chan []byte
	Events map[string]EventHandler
}

func NewWebSocket(w http.ResponseWriter, r *http.Request) (*WebSocket, error) {
	conn, err := upgrader.Upgrade(w, r, nil)
	if err != nil {
		log.Fatal(err.Error())
		return nil, err
	}

	ws := &WebSocket{
		Conn: conn,
		Out: make(chan []byte),
		In: make(chan []byte),
		Events: make(map[string]EventHandler),
	}

	go ws.Reader()
	go ws.Writer()
}

func (ws *WebSocket) Reader() {
	defer func() {
		ws.Conn.Close()
	}()
	for {
		_, message, err := ws.Conn.ReadMessage()
		if err != nil {
			if websocket.IsUnexpectedCloseError(err, websocket.CloseGoingAway, websocket.CloseAbnormalClosure) {
				log.Printf("WS Message Error: %v", err)
			}
			break
		}
		event, err := NewEventFromRaw(message)
		if err != nil {
			log.Fatalf("Error parsing message: %v", err)
		} else {
			fmt.Printf("Message: %v", event)
		}
		if action, ok := ws.Events[event.Name]; ok {
			action(event)
		}
		//TODO: Process data
	}
}

func (ws *WebSocket) Writer() {
	for {
		select {
			case message, ok := <- ws.Out:
				if !ok {
					ws.Conn.WriteMessage(websocket.CloseMessage, make([]byte, 0))
					return
				}
				w, err := ws.Conn.NextWriter(websocket.TextMessage)
				if err != nil {
					return
				}
				_, err = w.Write(message)
				if err != nil {
					log.Fatal(err)
					return
				}
				err = w.Close()
				if err != nil {
					log.Fatal(err)
					return
				}
		}
	}
}