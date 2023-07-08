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

istioctl operator init --watchedNamespaces istio-system --operatorNamespace istio-operator
kubectl apply -f istio/istio.yaml
kubectl get all -n istio-system -l istio.io/rev=default
kubectl apply -f istio/disable-mtls.yaml

helm repo add kiali https://kiali.org/helm-charts
helm repo update
helm install --version "1.70.0" -n kiali-operator -f kiali/operator-values.yaml kiali-operator kiali/kiali-operator
kubectl apply -f kiali/kiali.yaml
kubectl get po -n kiali -l app.kubernetes.io/name=kiali

helm install homework3-db oci://registry-1.docker.io/bitnamicharts/postgresql \
--set global.postgresql.auth.username=test,global.postgresql.auth.password=password,global.postgresql.auth.database=homework3 \
--set metrics.enabled=true

helm install app ./app/Helm