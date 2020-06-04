package service

import (
	"github.com/gorilla/websocket"
	"log"
	"net/http"
)

const (
	MaxMsgSize = 5000
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
		log.Fatalf("[ERROR] Socket connection failed %v", err)
		return nil, err
	}

	ws := &WebSocket{
		Conn:   conn,
		Out:    make(chan []byte),
		In:     make(chan []byte),
		Events: make(map[string]EventHandler),
	}

	go ws.Reader()
	go ws.Writer()
	return ws, nil
}

func (ws *WebSocket) Reader() {
	defer func() {
		_ = ws.Conn.Close()
	}()
	ws.Conn.SetReadLimit(MaxMsgSize)
	for {
		_, message, err := ws.Conn.ReadMessage()
		if err != nil {
			if websocket.IsUnexpectedCloseError(err, websocket.CloseGoingAway, websocket.CloseAbnormalClosure) {
				log.Fatalf("[ERROR]:  %v", err)
			}
			break
		}
		event, err := NewEventFromRaw(message)
		if err != nil {
			log.Panicf("[ERROR]: %v", err)
		} else {
			log.Printf("[MSG]: Eventname %v", event.Name)
		}
		if action, ok := ws.Events[event.Name]; ok {
			action(event)
		}
	}
}

func (ws *WebSocket) Writer() {
	for {
		select {
		case message, ok := <- ws.Out:
			if !ok {
				_ = ws.Conn.WriteMessage(websocket.CloseMessage, []byte{})
				return
			}
			w, err := ws.Conn.NextWriter(websocket.TextMessage)
			if err != nil {
				return
			}
			_, err = w.Write(message)
			if err != nil {
				log.Fatalf("[ERROR]: Write message failed %v", err)
			}
			_ = w.Close()
		}
	}
}

func (ws *WebSocket) On(eventName string, action EventHandler) *WebSocket {
	ws.Events[eventName] = action
	return ws
}