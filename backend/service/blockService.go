package service

import (
	"net/http"
)

func listen() {
	http.HandleFunc("/ws", func(w http.ResponseWriter, r *http.Request) {

	})

	http.ListenAndServe(":8000", nil)
}
