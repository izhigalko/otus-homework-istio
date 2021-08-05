.PHONY: runweb
runweb:
	minikube service -n kiali kiali-nodeport
	minikube service -n monitoring prometheus-grafana-nodeport
	minikube service -n monitoring prom-prometheus-nodeport
	minikube service -n jaeger jaeger-query-nodeport

.DEFAULT_GOAL := runweb