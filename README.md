# 1.9 Service mesh на примере Istio

## Развернуть Minikube
Так как у меня Mac:
```
brew install minikube
minikube start -p otus
eval $(minikube -p otus docker-env)
brew install istioctl

```

## Развернуть Istio c Ingress gateway

### Ставим ISTIO
```
istioctl install --set profile=demo
```

- ✔ Istio core installed
- ✔ Istiod installed
- ✔ Egress gateways installed
- ✔ Ingress gateways installed
- ✔ Installation complete

### Ставим Kiali

Так как Kiali зависит от prometheus, то сначала ставим его. А для трассировки запросов ставим jaeger.

```
kubectl apply -f https://raw.githubusercontent.com/istio/istio/release-1.7/samples/addons/prometheus.yaml
kubectl apply -f https://raw.githubusercontent.com/istio/istio/release-1.7/samples/addons/kiali.yaml
kubectl apply -f https://raw.githubusercontent.com/istio/istio/release-1.7/samples/addons/jaeger.yaml
```

Проверяем, что Kiali  установилась:
```
wwtlf@MacBook-Pro-Boris-2 ~ % kubectl -n istio-system get svc kiali
NAME    TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)              AGE
kiali   ClusterIP   10.100.125.15   <none>        20001/TCP,9090/TCP   4m8s
```
Смотрим ее dashboard:
```
istioctl dashboard kiali
```


- Развернуть две версии приложения с использованием Istio
- Настроить балансировку трафика между версиями приложения на уровне Gateway 50% на 50%
- Сделать снимок экрана с картой запросов в Kiali с примеров вызова двух версии сервиса