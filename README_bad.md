# Практика к занятию по теме "Service mesh на примере Istio"

## Установка компонентов
### Подготовка
Установить istioctl любым удобным способом.

Установить namespaces:
```
kubectl apply -f .\namespaces.yaml
```

Добавить необходимые репозитории в Helm:
```
helm repo add jaegertracing https://jaegertracing.github.io/helm-charts
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo add stable https://charts.helm.sh/stable
helm repo add kiali https://kiali.org/helm-charts
helm repo update
```
### Jaeger
Установить оператор, устанавливающий Jaeger:
```
helm install --version "2.19.0" -n jaeger-operator -f ./jaeger/operator-values.yaml jaeger-operator jaegertracing/jaeger-operator
```

Установить Jaeger:
```
kubectl apply -f ./jaeger/jaeger.yaml
```

### Prometheus
Установить Prometheus:
```
helm install -n monitoring -f ./prometheus/operator-values.yaml prometheus prometheus-community/kube-prometheus-stack
```

Добавить сервис типа NodePort для прямого доступа к Prometheus и Grafana:
```
kubectl apply -f ./prometheus/monitoring-nodeport.yaml
```

### Istio
Установить оператор:
```
istioctl operator init --watchedNamespaces istio-system --operatorNamespace istio-operator
```

Установить Istio:
```
kubectl apply -f ./istio/istio.yaml
```

Установить настройки шифрования:
```
kubectl apply -f ./istio/defaults.yaml
```
### Kiali
Установить Operator:
```
helm install --version "1.49.0" -n kiali-operator -f ./kiali/operator-values.yaml kiali-operator kiali/kiali-operator
```

Установить Kiali:
```
kubectl apply -f ./kiali/kiali.yaml
```

## Проверка компонентов
Jaeger:
```
kubectl get po -n jaeger -l app.kubernetes.io/instance=jaeger
```
Prometheus:
```
kubectl get po -n monitoring
```
Istio:
```
kubectl get all -n istio-system -l istio.io/rev=default
```
Kiali:
```
kubectl get po -n kiali -l app.kubernetes.io/name=kiali
```

## Панели управления компонентами
Jaeger:
```
minikube service -n jaeger jaeger-query-nodeport
```
Prometheus:
```
minikube service -n monitoring prom-prometheus-nodeport
```
Kiali:
```
minikube service -n kiali kiali-nodeport
```