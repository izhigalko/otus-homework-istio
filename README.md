# Практика к занятию по теме "Service mesh на примере Istio"

## How it was done
**istioctl** was installed according to [Getting Started](https://istio.io/latest/docs/setup/getting-started/)

and ```$ISTIO_HOME_PATH``` is a directory where **istioctl** is located

```
# start minikube and enable ingress
$ minikube start --memory=8192 --cpus=2 --vm=true
$ minikube addons enable ingress

# install IstioOperator
$ istioctl operator init --watchedNamespaces=istio-system
$ kubectl create ns istio-system
$ kubectl apply -f istio/operator.yaml

# add addons Kiali and Prometheus
$ kubectl apply -f ${ISTIO_HOME_PATH}/samples/addons/kiali.yaml
$ kubectl apply -f ${ISTIO_HOME_PATH}/samples/addons/prometheus.yaml

# mark default namespace as target for service-mesh and run our appliction
$ kubectl apply -f istio/ns-inject.yaml
$ kubectl apply -f app/echoserver.yaml
$ kubectl apply -f app/proxy-app.yaml

# add gateway on top of our application
$ kubectl apply -f istio/gateway.yaml

# get ip and port
$ minikube ip
$ kubectl -n istio-system get service istio-ingressgateway -o jsonpath='{.spec.ports[?(@.name=="http2")].nodePort}'

# call application to create a trafic
$ curl -X GET 'http://MINIKUBEIP:INGRESSGATEWAYPORT/?url=http://echoserver.default'

# see what we get
$ istioctl dashboard kiali
```

## Userful links
* https://istio.io/latest/docs/setup/getting-started/
* https://istio.io/latest/docs/tasks/traffic-management/ingress/ingress-control/
* https://kiali.io/documentation/latest/quick-start/
* https://istio.io/latest/docs/tasks/observability/kiali/

## Зависимости

Для выполнения задания вам потребуется установить зависимости:

- [VirtualBox](https://www.virtualbox.org/wiki/Downloads)
- [Vagrant](https://www.vagrantup.com/downloads.html)

После установки нужно запустить команду запуска в корне проекта:

```shell script
vagrant up
```

Для совершения всех операций нам понадобится зайти в виртуальную машину:

```shell script
vagrant ssh
```

## Содержание

* [Задачи](#Задачи)
* [Инструкция по выполнению задания](#Инструкция-по-выполнению-задания)
* [Лайфхаки по выполнению задания](#Лайфхаки-по-выполнению-задания)

## Задачи

Задание состоит из этапов

- Развернуть Istio с включенными метриками сервисов и Kiali
- Развернуть минимум два приложения с Service mesh и сделать к ним несколько запросов
- Отобразить карту сервисов в Kiali

Карта сервисов в Kiali выглядит таким образом:

![Карта сервисов](kiali-service-map.png)

## Инструкция по выполнению задания

- Сделать форк этого репозитория на Github
- Выполнить задание в отдельной ветке
- Создать Pull request с изменениями в этот репозиторий


## Лайфхаки по выполнению задания

Для выполнения задания вы можете воспользоваться [материалами демо](https://github.com/izhigalko/otus-demo-istio).

Спецификацию IstioOperator можно посмотреть
[в документации Istio](https://istio.io/latest/docs/reference/config/istio.operator.v1alpha1/#IstioOperatorSpec)
или можно посмотреть [исходники манифестов, исполняемых оператором](https://github.com/istio/istio/tree/1.6.4/manifests).

Директория `istio` в корне проекта расшарена в виртуальную машину, вы можете изменять файлы
в любимом редакторе и применять их в консоли виртуальной машины.

Если вы хотите изменить текущую конфигурацию Istio,
достаточно снова выполнить соответствующую команду с указанием конфигурации:

```shell script
istioctl manifest apply -f istio/istio-manifest.yaml
```

Для выключения шифрования между прокси, нужно применить настройку:

```shell script
kubectl apply -f istio/defaults.yaml
```

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

И сделать его проброс с помощью дополнительного флага
при подключении к виртуальной машине по ssh. Проброс портов заканчивается при завершении этой ssh сессии:

```yaml
vagrant ssh -- -L 32000:localhost:32080
```

Здесь `32080` - порт виртуальной машины, `32000` - порт хоста.
Сервис будет доступен по адресу `localhost:32000`.
