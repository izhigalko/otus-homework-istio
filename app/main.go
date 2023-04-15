package main

import (
	"context"
	"encoding/json"
	"fmt"
	"net/http"
	"os"
	"os/signal"
	"syscall"

	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
	"k8s.io/client-go/kubernetes"
	"k8s.io/client-go/rest"
)

const (
	defaultPort = 8000
)

func main() {
	http.HandleFunc("/", getPodInfoHandler)

	go func() {
		err := http.ListenAndServe(fmt.Sprintf(":%d", defaultPort), nil)
		if err != nil {
			panic(err)
		}
	}()

	fmt.Printf("app started on port %d\n", defaultPort)

	c := make(chan os.Signal, 1)
	signal.Notify(c, syscall.SIGINT, syscall.SIGTERM)
	<-c
	fmt.Println("gracefull shutdown...")
}

func getPodInfoHandler(w http.ResponseWriter, r *http.Request) {
	config, _ := rest.InClusterConfig()
	clientset, _ := kubernetes.NewForConfig(config)

	pod, _ := clientset.CoreV1().Pods("default").Get(context.TODO(), "nginx-6799fc88d8-mzmcj", metav1.GetOptions{})

	annotaionsList := map[string]string{}
	for annotationName, annotationValue := range pod.GetAnnotations() {
		annotaionsList[annotationName] = annotationValue
	}

	json.NewEncoder(w).Encode(map[string]interface{}{"app_version": "v0.0.2", "pod_name": pod.Name, "namespace": pod.Namespace, "annotations": annotaionsList})
}
