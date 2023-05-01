package main

import (
	"fmt"
	"net"
	"net/http"
)

func health(w http.ResponseWriter, r *http.Request) {
	host, port, _ := net.SplitHostPort(r.RemoteAddr)
	response := fmt.Sprintf("{\"status\":\"OK\",\"host\":\"%s\",\"port\":\"%s\"}\n",
		host, port)
	fmt.Fprintf(w, response)
}

func main() {
	http.HandleFunc("/health/", health)
	http.ListenAndServe(":8000", nil)
}
