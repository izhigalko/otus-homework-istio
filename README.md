# Практика к занятию по теме "Service mesh на примере Istio"

## Зависимости

Для выполнения задания вам потребуется установить зависимости:

- [Minikube 1.13.1](https://github.com/kubernetes/minikube/releases/tag/v1.13.1)
- [Kubectl 0.19.2](https://github.com/kubernetes/kubectl/releases/tag/v0.19.2)
- [Istioctl 1.7.3](https://github.com/istio/istio/releases/tag/1.9.0)
- [Helm 3.3.4](https://github.com/helm/helm/releases/tag/v3.3.4)

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
kubectl apply -f istio/istio-manifest.yaml
```

---

Для выключения шифрования между прокси, нужно применить настройку:

```shell script
kubectl apply -f istio/defaults.yaml
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

## Запуск

```bash
minikube start \
--cpus=4 --memory=8g \
--cni=flannel \
--kubernetes-version="v1.19.0" \
--extra-config=apiserver.enable-admission-plugins=NamespaceLifecycle,LimitRanger,ServiceAccount,DefaultStorageClass,\
DefaultTolerationSeconds,NodeRestriction,MutatingAdmissionWebhook,ValidatingAdmissionWebhook,ResourceQuota,PodPreset \
--extra-config=apiserver.authorization-mode=Node,RBAC

kubectl apply -f namespaces.yaml

helm repo add jaegertracing https://jaegertracing.github.io/helm-charts
helm repo update

helm install --version "2.19.0" -n jaeger-operator -f jaeger/operator-values.yaml \
jaeger-operator jaegertracing/jaeger-operator

kubectl apply -f jaeger/jaeger.yaml

#check
kubectl get po -n jaeger -l app.kubernetes.io/instance=jaeger

#open
minikube service -n jaeger jaeger-query-nodeport

helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo add stable https://kubernetes-charts.storage.googleapis.com/
helm repo update

helm install --version "13.7.2" -n monitoring -f prometheus/operator-values.yaml prometheus \
prometheus-community/kube-prometheus-stack

#check
kubectl get po -n monitoring

kubectl apply -f prometheus/monitoring-nodeport.yaml

#open
minikube service -n monitoring prometheus-grafana-nodeport
minikube service -n monitoring prom-prometheus-nodeport


curl -L https://istio.io/downloadIstio | ISTIO_VERSION=1.9.0 sh -
export PATH="$PATH:/home/alex/istio-1.9.0/bin"

istioctl operator init --watchedNamespaces istio-system --operatorNamespace istio-operator
kubectl apply -f istio/istio-manifest.yaml

#check
kubectl get all -n istio-system -l istio.io/rev=default

helm repo add kiali https://kiali.org/helm-charts
helm repo update

helm install --version "1.33.1" -n kiali-operator kiali-operator kiali/kiali-operator

kubectl apply -f kiali/kiali.yaml

#change image version
kubectl edit deploy -n kiali kiali

#check
kubectl get po -n kiali -l app.kubernetes.io/name=kiali

minikube service -n kiali kiali-nodeport

sudo docker login
sudo docker build --network=host --build-arg service_version=v1 --tag adyakonov/hello-app:v1 .
sudo docker push adyakonov/hello-app:v1
sudo docker build --network=host --build-arg service_version=v2 --tag adyakonov/hello-app:v2 .
sudo docker push adyakonov/hello-app:v2

kubectl apply -f hello-py/app_manifest.yaml
kubectl apply -f gateway.yaml

minikube service hello

curl "$(minikube service hello --url)/version?url=http://hello/"
```