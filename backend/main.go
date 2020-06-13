package main

import (
	Service "./service"
	"log"
	"net/http"
	"strconv"
)

func main() {
	//Websocket test using a small web page
	http.Handle("/", http.FileServer(http.Dir("./assets")))

	listen(8080)
}

func listen(port int) {
	http.HandleFunc("/ws", func(w http.ResponseWriter, r *http.Request) {
		ws, err := Service.NewWebSocket(w, r)
		if err != nil {
			log.Panicf("Error creating websocket connection: %v", err)
			return
		}

		//.On == receive
		ws.On("message", func(event *Service.Event) {
			log.Printf("Message received: %v", event.Data.(string)) //Cast to String can result to an error

			//Out = send
			ws.Out <- (&Service.Event {
				Name: "response",
				Data: event.Data.(string),
			}).ToRaw()
		})
	})

	log.Printf("WebServer listening on port %v\n", port)
	_ = http.ListenAndServe(":"+strconv.Itoa(port), nil)
}

func onMessage() {
		
}
