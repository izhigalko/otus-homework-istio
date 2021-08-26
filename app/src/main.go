
package main

import (
	"encoding/json"
	"fmt"
	"log"
	"net/http"
	"os"

	"github.com/gorilla/mux"
	"github.com/gorilla/handlers"
	"github.com/ilyakaznacheev/cleanenv"
)

type Config struct {
	Port int `env:"PORT" env-default:"8080"`
}

func ReadConfig() (*Config, error) {
	var config Config
	err := cleanenv.ReadEnv(&config)
	if err != nil {
		return nil, err
	}
	if os.Getenv("IS_DEV") != "" {
		err = cleanenv.ReadConfig(".env", &config)
	}

	return &config, err
}

func mainHandler(w http.ResponseWriter, r *http.Request) {
	headers := ""
	for k, v := range r.Header {
		headers += fmt.Sprintf("%s: %s\n", k, v)
	}
	result := fmt.Sprintf("%s %s %s\n\n%s", r.Host, r.Method, r.URL, headers)
	w.Write([]byte(result))
}

func healthHandler(w http.ResponseWriter, r *http.Request) {
	err := json.NewEncoder(w).Encode(map[string]string{"status": "OK"})
	if err != nil {
		fmt.Printf("Error occurred %s", err)
	}
}

func main() {
	cfg, err := ReadConfig()
	if err != nil {
		log.Fatal(err)
	}

	r := mux.NewRouter()
	r.HandleFunc("/", mainHandler).Methods("GET")
	r.HandleFunc("/health", healthHandler).Methods("GET")

	loggedRouter := handlers.LoggingHandler(os.Stdout, r)

	fmt.Printf("Starting server at port %d \n", cfg.Port)
	log.Fatal(http.ListenAndServe(fmt.Sprintf(":%d", cfg.Port), loggedRouter))
}