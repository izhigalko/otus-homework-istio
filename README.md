# Практика к занятию по теме "Service mesh на примере Istio"

kubectl apply -f namespaces.yaml

helm repo add jetstack https://charts.jetstack.io
helm install cert-manager --namespace cert-manager --version v1.12.2 jetstack/cert-manager

helm repo add jaegertracing https://jaegertracing.github.io/helm-charts
helm repo update
helm install -n jaeger-operator -f jaeger/operator-values.yaml jaeger-operator jaegertracing/jaeger-operator
kubectl apply -f jaeger/jaeger.yaml

helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo add stable https://charts.helm.sh/stable
helm repo update
helm install -n monitoring prometheus -f ./prometheus/operator-values.yaml prometheus-community/kube-prometheus-stack
kubectl apply -f prometheus/monitoring-nodeport.yaml