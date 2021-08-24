Зависимости:

- [Minikube 1.13.1](https://github.com/kubernetes/minikube/releases/tag/v1.13.1)
- [Kubectl 0.19.2](https://github.com/kubernetes/kubectl/releases/tag/v0.19.2)
- [Istioctl 1.9.0](https://github.com/istio/istio/releases/tag/1.9.0)
- [Heml 3.3.4](https://github.com/helm/helm/releases/tag/v3.3.4)

После установки нужно запустить Kubernetes. При необходимости можно изменить используемый драйвер с помощью
флага `--driver`. 

```shell script
minikube start \
--cpus=4 --memory=8g \
--cni=flannel \
--kubernetes-version="v1.19.0" \
--extra-config=apiserver.enable-admission-plugins=NamespaceLifecycle,LimitRanger,ServiceAccount,DefaultStorageClass,\
DefaultTolerationSeconds,NodeRestriction,MutatingAdmissionWebhook,ValidatingAdmissionWebhook,ResourceQuota,PodPreset \
--extra-config=apiserver.authorization-mode=Node,RBAC
```

Создать неймспейсы для операторов:

```shell script
kubectl apply -f namespaces.yaml
```

Добавить репозиторий Jaeger в Helm:

```shell script
helm repo add jaegertracing https://jaegertracing.github.io/helm-charts
helm repo update
```

Установить оператор, разворачивающий Jaeger:

```shell script
helm install --version "2.19.0" -n jaeger-operator -f jaeger/operator-values.yaml \
jaeger-operator jaegertracing/jaeger-operator
``` 

Развернуть Jaeger:

```shell script
kubectl apply -f jaeger/jaeger.yaml
```

Открыть web-интерфейс Jaeger:

```shell script
minikube service -n jaeger jaeger-query-nodeport
```

Добавить репозиторий Prometheus в Helm:

```shell script
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo add stable https://kubernetes-charts.storage.googleapis.com/
helm repo update
```

Развернуть решение по мониторингу на основе Prometheus:

```shell script
helm install --version "13.7.2" -n monitoring -f prometheus/operator-values.yaml prometheus \
prometheus-community/kube-prometheus-stack
``` 

Проверить состояние компонентов мониторинга:

```shell script
kubectl get po -n monitoring
```

Добавить сервис типа NodePort для прямого доступа к Prometheus и Grafana:

```shell script
kubectl apply -f prometheus/monitoring-nodeport.yaml
```

Открыть web-интерфейс Grafana:

```shell script
minikube service -n monitoring prometheus-grafana-nodeport
```

Открыть web-интерфейс Prometheus:

```shell script
minikube service -n monitoring prom-prometheus-nodeport
```

Установить оператор, разворачивающий Istio:

```shell script
istioctl operator init --watchedNamespaces istio-system --operatorNamespace istio-operator
```

Развернуть Istio c помощью оператора:

```shell script
kubectl apply -f istio/istio.yaml
```

Добавить репозиторий Kiali в Helm:

```shell script
helm repo add kiali https://kiali.org/helm-charts
helm repo update
```

Установить Kiali Operator, разворачивающий Kiali

```shell script
helm install --version "1.33.1" -n kiali-operator kiali-operator kiali/kiali-operator
```

Развернуть Kiali:

```shell script
kubectl apply -f kiali/kiali.yaml
```

Открыть web-интерфейс Kiali:

```shell script
minikube service -n kiali kiali-nodeport
```

Echoserver - сервис, отдающий в виде текста параметры входящего HTTP запроса.

Собрать Docker-образ:

```shell script
eval $(minikube docker-env) && docker build -t proxy-app:latest -f app/src/Dockerfile app/src
```

Развернуть приложение `echoserver` в двух экземплярах в кластере:

```shell script
kubectl apply -f app/echoserver.yaml
```

Настроить балансировку:

```shell script
kubectl apply -f app/gateway.yaml
```

Выполнить запрос к сервису:

```shell script
curl $(minikube service echoserver --url)
```

Proxy-app - сервис, умеющий запрашивать другие запросы по query-параметру url. 

Развернуть приложение `proxy-app` в кластере:

```shell script
kubectl apply -f app/proxy-app.yaml
```

Выполнить запрос к сервису:

```shell script
curl $(minikube service proxy-app --url)
```

Собрать нагрузочный образ:

```shell script
eval $(minikube docker-env) && docker build -t load-otus-demo:latest -f app/load/Dockerfile app/load
```

Запустить нагрузочный образ:

```shell script
kubectl apply -f app/load.yaml
```

