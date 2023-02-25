# Практика к занятию по теме "Service mesh на примере Istio"

## ДЗ

Добавляем namespaces:

```kubectl apply -f namespaces.yaml```

## Установка Istio
Качаем нужную версию:
```https://github.com/istio/istio/releases/tag/1.17.0```

Устанавливаем:
```.\istioctl operator init --watchedNamespaces istio-system,echoserver-istio --operatorNamespace istio-operator```

Применяем настройки:
``` kubectl apply -f istio/istio-manifest.yaml```

Что бы добавить ресурсов, необходимо пересоздать (удалятся все наработки):
minikube delete
minikube start --vm-driver=hyperv --cpus=6 --memory=8g

Установка namespaces:
```shell
kubectl apply -f .\infra
```

## Jaeger
Добавление репозитория в Helm:
```shell
helm repo add jaegertracing https://jaegertracing.github.io/helm-charts
helm repo update
```
Требуется установка сертификата:
```shell
helm install --namespace cert-manager --create-namespace cert-manager jetstack/cert-manager --set installCRDs=true
```
Установка через оператор:
```shell
helm install --namespace jaeger-operator --create-namespace jaeger-operator jaegertracing/jaeger-operator -f ./jaeger/operator-values.yaml
```
Настраиваем: 
```shell
kubectl apply -f jaeger/jaeger.yaml
```
Проверить:
```shell
kubectl get po -n jaeger -l app.kubernetes.io/instance=jaeger
```
Открыть веб-интерфейс:
```shell
minikube service -n jaeger jaeger-query-nodeport
```
## Prometheus
Добавление репозитория в Helm:
```shell
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo add stable https://kubernetes-charts.storage.googleapis.com/
helm repo update
```
Развернуть:
```shell
helm install -n monitoring -f prometheus/operator-values.yaml prometheus prometheus-community/kube-prometheus-stack
```
Проверить:
```shell
kubectl get po -n monitoring
```
Добавить сервис типа NodePort для прямого доступа к Prometheus и Grafana:
```shell
kubectl apply -f prometheus/monitoring-nodeport.yaml
```
Открыть web-интерфейс Grafana:
```shell
minikube service -n monitoring prometheus-grafana-nodeport
```
Открыть web-интерфейс Prometheus:
```shell
minikube service -n monitoring prom-prometheus-nodeport
```
## Istio
Установить:
```shell
./istioctl operator init
```
Настроить:
```shell
kubectl apply -f istio/istio-manifest.yaml
```
Проверить состояние Istio:
```shell
kubectl get all -n istio-system -l istio.io/rev=default
```

## Kiali
С isito-proxy не стартовал.

Добавить репозиторий в Helm:
```shell
helm repo add kiali https://kiali.org/helm-charts
helm repo update
```
Установка через оператор:
```shell
helm install --namespace kiali-operator --create-namespace kiali-operator kiali/kiali-operator
```
Развернуть:
```shell
kubectl apply -f kiali/kiali.yaml
```
Проверить состояние Kiali:
```shell
kubectl get po -n kiali -l app.kubernetes.io/name=kiali
```
Открыть web-интерфейс Kiali:
```shell
minikube service -n kiali kiali-nodeport
```