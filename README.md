# Практика к занятию по теме "Service mesh на примере Istio"

kubectl apply -f namespaces.yaml

helm repo add jaegertracing https://jaegertracing.github.io/helm-charts
helm repo update

helm install --version "2.19.0" -n jaeger-operator -f jaeger/operator-values.yaml jaeger-operator jaegertracing/jaeger-operator