
## Зависимости

Задание выполнялось при помощи

- Minikube 1.17.1
- Kubectl 1.19.3
- Istioctl 1.9.0
- Heml 3.5.1

## Запуск Kubernetes 

```shell script
minikube start --cpus=4 --memory=8g --cni=flannel --kubernetes-version="v1.19.0" --extra-config=apiserver.enable-admission-plugins=NamespaceLifecycle,LimitRanger,ServiceAccount,DefaultStorageClass,DefaultTolerationSeconds,NodeRestriction,MutatingAdmissionWebhook,ValidatingAdmissionWebhook,ResourceQuota,PodPreset --extra-config=apiserver.authorization-mode=Node,RBAC
```

## Манифесты находятся в папке devops 

Создать неймспейсы для операторов:

```shell script
kubectl apply -f namespaces.yaml
```

### Разворачиваем Jaeger

```shell script
helm repo add jaegertracing https://jaegertracing.github.io/helm-charts
helm repo update
helm install --version "2.19.0" -n jaeger-operator -f jaeger/operator-values.yaml jaeger-operator jaegertracing/jaeger-operator
kubectl apply -f jaeger/jaeger.yaml
```

### Разворачиваем Prometheus

```shell script
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo add stable https://charts.helm.sh/stable
helm repo update
helm install --version "13.7.2" -n monitoring -f prometheus/operator-values.yaml prometheus prometheus-community/kube-prometheus-stack
kubectl apply -f prometheus/monitoring-nodeport.yaml
```

### Разворачиваем Istio 

```shell script
istioctl operator init --watchedNamespaces istio-system --operatorNamespace istio-operator
kubectl apply -f istio/istio.yaml
```

### Устанавливаем Kiali

```shell script
helm repo add kiali https://kiali.org/helm-charts
helm repo update
helm install --version "1.29.1" -n kiali-operator kiali-operator kiali/kiali-operator
kubectl apply -f kiali/kiali.yaml
```

### Устанавливаем приложение

```shell script
kubectl apply -f app/app.yaml
kubectl apply -f app/istio.yaml
```
