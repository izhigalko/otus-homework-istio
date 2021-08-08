# Практика к занятию по теме "Service mesh на примере Istio"

## Зависимости
Необходимо установить зависимости:

- [Minikube 1.13.1](https://github.com/kubernetes/minikube/releases/tag/v1.13.1)
- [Kubectl 0.19.2](https://github.com/kubernetes/kubectl/releases/tag/v0.19.2)
- [Istioctl 1.7.3](https://github.com/istio/istio/releases/tag/1.9.0)
- [Helm 3.3.4](https://github.com/helm/helm/releases/tag/v3.3.4)


## Подготовка к установке
Создать неймспейсы для операторов:
```bash
kubectl apply -f namespaces.yaml
```

## Разворачиваем Prometheus
Добавить репозиторий в Helm:
```bash
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo add stable https://charts.helm.sh/stable
helm repo update
```
Развернуть решение по мониторингу на основе Prometheus:
```bash
helm install --version "13.7.2" -n monitoring -f prometheus/operator-values.yaml prometheus \
prometheus-community/kube-prometheus-stack
````
Проверить состояние компонентов мониторинга:
```bash
kubectl get po -n monitoring
```

## Разворачиваем Istio
Установить оператор, разворачивающий Istio:
```bash
istioctl operator init --watchedNamespaces istio-system --operatorNamespace istio-operator
```
Развернуть Istio c помощью оператора:
```bash
kubectl apply -f istio/istio.yaml
```
Проверить состояние Istio:
```bash
kubectl get all -n istio-system -l istio.io/rev=default
```

## Устанавливаем Kiali
Добавить репозиторий в Helm:
```bash
helm repo add kiali https://kiali.org/helm-charts
helm repo update
```
Установить Kiali Operator, разворачивающий Kiali
```bash
helm install --version "1.33.1" -n kiali-operator kiali-operator kiali/kiali-operator
```

Развернуть Kiali:
```bash
kubectl apply -f kiali/kiali.yaml
```
Проверить состояние Kiali:
```bash
kubectl get po -n kiali -l app.kubernetes.io/name=kiali
```

Открыть web-интерфейс Kiali:
```bash
minikube service -n kiali kiali-nodeport
```

## Устанавливаем приложение
Собрать образ:
```bash
eval $(minikube docker-env) && docker build -t istio-demo-app .
```
Разворачиваем приложение:
```bash
kubectl apply -f app_manifests
```
Нагружаем приложение, например:
```bash
wrk -t2 -c5 -d120s http://{MINIKUBE_IP}:{ISTIO_INGRESSGATEWAY_NODE_PORT}/status
```
