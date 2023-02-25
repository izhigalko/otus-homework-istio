### Создаём алиасы:
```shell
alias mi='minikube'
alias ku='kubectl'
```

### Запускаем minikube:
```shell
minikube start --driver hyperv --cpus=4 --memory=8g --cni=flannel --kubernetes-version="v1.19.0"
```

### Установить Istio:
```shell
istioctl install --set profile=default -y
```

### Создаём namespace:
```shell
ku apply -f namespaces.yaml
```

### Разворачиваем Jaeger
Jaeger - решение трассировки. Компоненты Istio, такие как: sidecar-контейнер, gateway, отправляют данные запросов в систему. Таким образом получается полная трассировка запроса.

Добавить репозиторий в Helm:
```shell
helm repo add jaegertracing https://jaegertracing.github.io/helm-charts
helm repo update
```
Установить оператор, разворачивающий Jaeger и развернуть Jaeger:
```shell
helm install --version "2.19.0" -n jaeger-operator -f jaeger/operator-values.yaml jaeger-operator jaegertracing/jaeger-operator

kubectl apply -f jaeger/jaeger.yaml

minikube service -n jaeger jaeger-query-nodeport
```

### Разворачиваем Prometheus
Prometheus - система мониторинга. С помощью неё собираются метрики Service mesh.
Добавить репозиторий в Helm:
```shell
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo add stable https://kubernetes-charts.storage.googleapis.com/
helm repo update
```
Развернуть решение по мониторингу на основе Prometheus:
```shell
helm install --version "13.7.2" -n monitoring -f prometheus/operator-values.yaml prometheus prometheus-community/kube-prometheus-stack
```
Добавить сервис типа NodePort для прямого доступа к Prometheus и Grafana:
```shell
kubectl apply -f prometheus/monitoring-nodeport.yaml
```

Открыть web-интерфейс Prometheus:
```shell
minikube service -n monitoring prom-prometheus-nodeport
```

### Устанавливаем Kiali

```shell
helm repo add kiali https://kiali.org/helm-charts
helm repo update
helm install --version "1.33.1" -n kiali-operator -f kiali/operator-values.yaml kiali-operator kiali/kiali-operator
kubectl apply -f kiali/kiali.yaml
minikube service -n kiali kiali-nodeport
```

### Применяем манифесты приложения:
```shell
kubectl apply -f manifests/
```

### Выполняем несколько запросов в IngressGateway (для minikube)
#### Получаем nodePort
```shell
kubectl get service istio-ingressgateway --namespace istio-system -o jsonpath='{.spec.ports[?(@.name=="http2")].nodePort}'
```

### Добавляем route на хост-машине к сервису:
```shell
minikube tunnel
```

### Нагружаем и смотрим распределение.