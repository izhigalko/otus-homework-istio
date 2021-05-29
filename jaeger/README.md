```shell
helm repo add jaegertracing https://jaegertracing.github.io/helm-charts
helm repo update

helm install -n jaeger-operator -f jaeger/values.yaml \
jaeger-operator jaegertracing/jaeger-operator

kubectl apply -f jaeger/jaeger.yaml
```