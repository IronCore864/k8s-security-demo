package main

import (
	"fmt"
	"log"
	"net/http"
)

func main() {
	http.HandleFunc("/", helloServer)
	log.Println("Server started on 8080.")
	http.ListenAndServe(":8080", nil)
}

func helloServer(w http.ResponseWriter, r *http.Request) {
	fmt.Fprintf(w, "Hello, world!")
}
