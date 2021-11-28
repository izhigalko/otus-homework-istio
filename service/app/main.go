package main

import (
	"encoding/json"
	"errors"
	"fmt"
	"log"
	"net/http"
	"os"
	"time"

	"github.com/gofrs/uuid"
	"github.com/gorilla/handlers"
)

const (
	defaultPort = "8000"
)

var (
	version = ""
	appID   = uuid.Must(uuid.NewV4())
)

func main() {
	port := os.Getenv("PORT")
	if port == "" {
		port = defaultPort
	}

	server := createServer(port)

	log.Println("starting http server at", port)
	err := server.ListenAndServe()
	if err != nil && !errors.Is(err, http.ErrServerClosed) {
		log.Fatalln(err)
	}
}

func createServer(port string) *http.Server {
	var handler http.Handler
	handler = createRouter()
	handler = handlers.CombinedLoggingHandler(os.Stdout, handler)

	return &http.Server{Addr: ":" + port, Handler: handler}
}

func createRouter() *http.ServeMux {
	mux := http.NewServeMux()

	mux.HandleFunc("/health", func(writer http.ResponseWriter, request *http.Request) {
		writer.Header().Set("content-type", "application/json")
		writer.WriteHeader(http.StatusOK)
		writer.Write([]byte(`{"status":"ok"}`))
	})

	mux.HandleFunc("/ready", func(writer http.ResponseWriter, request *http.Request) {
		writer.Header().Set("content-type", "application/json")
		writer.WriteHeader(http.StatusOK)
		writer.Write([]byte(`{"status":"ok"}`))
	})

	mux.HandleFunc("/version", func(writer http.ResponseWriter, request *http.Request) {
		writer.Header().Set("content-type", "application/json")
		writer.WriteHeader(http.StatusOK)
		writer.Write([]byte(fmt.Sprintf(`{"version":"%s"}`, version)))
	})

	mux.HandleFunc("/", func(writer http.ResponseWriter, request *http.Request) {
		writer.Header().Set("content-type", "application/json")
		writer.WriteHeader(http.StatusOK)
		response, _ := json.Marshal(struct {
			ApplicationID      uuid.UUID `json:"application_id"`
			ApplicationVersion string    `json:"application_version"`
			UserAgent          string    `json:"user_agent"`
			Timestamp          string    `json:"timestamp"`
		}{
			ApplicationID:      appID,
			ApplicationVersion: version,
			UserAgent:          request.UserAgent(),
			Timestamp:          time.Now().Format(time.RFC3339),
		})

		writer.Write(response)
	})

	return mux
}
