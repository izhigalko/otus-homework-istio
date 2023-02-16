# Практика к занятию по теме "Service mesh на примере Istio"

## Зависимости

Для выполнения задания вам потребуется установить зависимости:

- [Minikube 1.29.0](https://github.com/kubernetes/minikube/releases/tag/v1.20.0)
- [Kubectl 0.19.2](https://github.com/kubernetes/kubectl/releases/tag/v0.19.2)
- [Istioctl 1.17.0](https://github.com/istio/istio/releases/tag/1.17.0)
- [Helm 3.11.1](https://github.com/helm/helm/releases/tag/v3.11.1)

## Содержание

* [Задачи](#Задачи)
* [Инструкция по выполнению задания](#Инструкция-по-выполнению-задания)
* [Лайфхаки по выполнению задания](#Лайфхаки-по-выполнению-задания)

## Задачи

Задание состоит из этапов

- Развернуть Minikube
- Развернуть Istio c Ingress gateway
- Развернуть две версии приложения с использованием Istio
- Настроить балансировку трафика между версиями приложения на уровне Gateway 50% на 50%
- Сделать снимок экрана с картой сервисов в Kiali с примеров вызова двух версии сервиса

![Пример карты сервисов с балансировкой трафика между версиями](kiali-map-example.png)

## Инструкция по выполнению задания

- Сделать форк этого репозитория на Github
- Выполнить задание в отдельной ветке
- Создать Pull request с изменениями в этот репозиторий

## Разворачивание Istio-кластера

- Добавление необходимых репозиториев в Helm
```shell
helm repo add jetstack https://charts.jetstack.io
helm repo add kiali https://kiali.org/helm-charts
helm repo update
```

- Создание пространств имён
```shell
kubectl apply -f ./namespaces.yaml
```

- Установка стека Prometheus для Kubernetes
```shell
helm install --namespace monitoring --create-namespace prometheus prometheus-community/kube-prometheus-stack -f ./prometheus/operator-values.yaml --atomic
kubectl apply -f ./prometheus/node-ports.yaml
```

- Установка cert-manager
```shell
helm install --namespace cert-manager --create-namespace cert-manager jetstack/cert-manager --set installCRDs=true
```

- Установка Jaeger
```shell
helm install --namespace jaeger-operator --create-namespace jaeger-operator jaegertracing/jaeger-operator -f ./jaeger/operator-values.yaml
kubectl apply -f ./jaeger/jaeger.yaml
kubectl apply -f ./jaeger/node-ports.yaml
```

- Установка оператора Istio средствами istioctl
```shell
istioctl operator init
```

- Разворачивание Istio
```shell
kubectl apply -f ./istio/istio.yaml
```

- Установка Kiali
```shell
helm install --namespace kiali-operator --create-namespace kiali-operator kiali/kiali-operator
kubectl apply -f ./kiali/kiali.yaml
kubectl apply -f ./kiali/node-ports.yaml
```

- Разворачивание приложения hello и Istio-ингресса к нему
```shell
kubectl apply -f ./app/app.yaml
kubectl apply -f ./app/istio-ingress.yaml
```

## Тестовая нагрузка приложения

В каталоге k6-scripts находится скрипт для утилиты K6.
Пример запуска (10 VU в течение 30 секунд):
```shell
k6 run ./k6-scripts/load-app.js --vus=10 --duration=30s
```

## Лайфхаки по выполнению задания

Для выполнения задания вы можете воспользоваться [материалами демо](https://github.com/izhigalko/otus-demo-istio).

---

Спецификацию IstioOperator можно посмотреть
[в документации Istio](https://istio.io/latest/docs/reference/config/istio.operator.v1alpha1/#IstioOperatorSpec)
или можно посмотреть [исходники манифестов, исполняемых оператором](https://github.com/istio/istio/tree/master/manifests).

---

Если вы хотите изменить текущую конфигурацию Istio,
достаточно применить манифест с указанием конфигурации:

```shell script
kubectl apply -f istio/istio.yaml
```

---

Для доступа к какому-либо сервису с хоста можно использовать тип NodePort в сервисе:

```yaml
---
apiVersion: v1
kind: Service
metadata:
  name: test
  namespace: default
spec:
  type: NodePort
  ports:
    - port: 80
      nodePort: 32080
      targetPort: 8080
  selector:
    app: test
```

Использовать специальную команду для доступа к сервису:

```yaml
minikube service -n <namespace> <service>
```
