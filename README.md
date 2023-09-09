# Практика к занятию по теме "Service mesh на примере Istio"

1. minikube start --cpus=4 --memory=12gb  --disk-size=8gb --cni=flannel --kubernetes-version="v1.19.0"
1. kubectl apply -f namespaces.yaml

2. helm repo add jaegertracing https://jaegertracing.github.io/helm-charts
3. helm repo update
4. helm install --version "2.19.0" -n jaeger-operator -f jaeger/operator-values.yaml jaeger-operator jaegertracing/jaeger-operator
5. kubectl apply -f jaeger/jaeger.yaml
6. kubectl get po -n jaeger -l app.kubernetes.io/instance=jaeger
7. minikube service -n jaeger jaeger-query-nodeport

7. helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
8. helm repo add stable https://charts.helm.sh/stable
9. helm repo update
8. helm install --version "13.7.2" -n monitoring -f prometheus/operator-values.yaml prometheus prometheus-community/kube-prometheus-stack
9. kubectl get po -n monitoring
10. kubectl apply -f prometheus/monitoring-nodeport.yaml
11. minikube service -n monitoring prometheus-grafana-nodeport
12. minikube service -n monitoring prom-prometheus-nodeport

13. istioctl operator init --watchedNamespaces istio-system --operatorNamespace istio-operator
14. kubectl apply -f istio/istio.yaml
15. kubectl get all -n istio-system -l istio.io/rev=default
16. kubectl apply -f istio/disable-mtls.yaml

17. helm repo add kiali https://kiali.org/helm-charts
19. helm repo update
20. helm install --version "1.33.1" -n kiali-operator -f kiali/operator-values.yaml kiali-operator kiali/kiali-operator
21. kubectl apply -f kiali/kiali.yaml
22. kubectl get po -n kiali -l app.kubernetes.io/name=kiali
23. minikube service -n kiali kiali-nodeport

24. eval $(minikube docker-env) && docker build -t proxy-app:latest -f app/src/Dockerfile app/src
25. kubectl apply -f app/echoserver.yaml
26. kubectl get po -l "app=echoserver"
27. curl $(minikube service echoserver --url)
28. kubectl apply -f app/proxy-app.yaml
29. kubectl get po -l "app=proxy-app"
30. curl $(minikube service proxy-app --url)
31. kubectl logs -l app=proxy-app 
32. eval $(minikube docker-env) && docker build -t load-otus-demo:latest -f app/load/Dockerfile app/load
33. kubectl apply -f app/load.yaml
34. kubectl logs -l app=load
35. curl "$(minikube service proxy-app --url)?url=http://echoserver"
36. kubectl apply -f manage-traffic/proxy-app-sidecar-disable.yaml
37. curl "$(minikube service proxy-app --url)?url=http://echoserver"
38. kubectl apply -f manage-traffic/proxy-app-sidecar-enable.yaml
39. curl "$(minikube service proxy-app --url)?url=http://echoserver"
40. kubectl apply -f auth/echoserver-auth.yaml
41. curl "$(minikube service proxy-app --url)?url=http://echoserver"
42. curl -H "X-AUTH-TOKEN: token" "$(minikube service proxy-app --url)?url=http://echoserver"
43. kubectl apply -f auth/proxy-app-auth.yaml
44. curl "$(minikube service proxy-app --url)?url=http://echoserver"
45. curl "$(minikube service proxy-app --url)?url=http://echoserver/error?times=3"
46. curl "$(minikube service proxy-app --url)?url=http://echoserver/error?times=3"
47. curl "$(minikube service proxy-app --url)?url=http://echoserver/error?times=3"
48. curl "$(minikube service proxy-app --url)?url=http://echoserver/error?times=3"
49. kubectl apply -f retries/echoserver-retries.yaml
50. curl "$(minikube service proxy-app --url)?url=http://echoserver/error?times=3"

#
1. kubectl apply -f ./kubernetes/namespace.yaml
2. kubectl apply -f ./kubernetes/deployment.yaml
3. kubectl apply -f ./kubernetes/gateway.yaml
4. kubectl apply -f ./kubernetes/destination-rule.yaml
5. kubectl apply -f ./kubernetes/virtual-service.yaml
6. curl -H "X-AUTH-TOKEN: token" "$(minikube service ms-hw-5-service --url)?url=http://echoserver/"
7. curl -H "X-AUTH-TOKEN: token" "$(minikube service ms-hw-5-service --url)?url=http://echoserver/"
8. curl -H "X-AUTH-TOKEN: token" "$(minikube service ms-hw-5-service --url)?url=http://echoserver/"
9. curl -H "X-AUTH-TOKEN: token" "$(minikube service ms-hw-5-service --url)?url=http://echoserver/"
10. curl -H "X-AUTH-TOKEN: token" "$(minikube service ms-hw-5-service --url)?url=http://echoserver/"


![img.png](img.png)

## Зависимости

Для выполнения задания вам потребуется установить зависимости:

- [Minikube 1.13.1](https://github.com/kubernetes/minikube/releases/tag/v1.13.1)
- [Kubectl 0.19.2](https://github.com/kubernetes/kubectl/releases/tag/v0.19.2)
- [Istioctl 1.7.3](https://github.com/istio/istio/releases/tag/1.9.0)
- [Heml 3.3.4](https://github.com/helm/helm/releases/tag/v3.3.4)

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
kubectl apply -f istio/istio-manifest.yaml.back
```

---

Для выключения шифрования между прокси, нужно применить настройку:

```shell script
kubectl apply -f istio/defaults.yaml.back
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
