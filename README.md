# Практика к занятию по теме "Service mesh на примере Istio"

## Установка компонентов
### Подготовка
Установить istioctl любым удобным способом.

Добавить необходимые репозитории в Helm:

### Istio
Установить Istio:
```
istioctl install --set profile=demo -y
kubectl label namespace default istio-injection=enabled
```

### Application
Установить приложение
```
helm install lisitsynapp .\myapp-chart\ -f .\myapp-chart\values.yaml
```

### Istio Services
Установить объекты Istio
```
kubectl apply -f .\istio\istio.yaml
```

Проверить, что все ок
```
istioctl analyze
```

### Kiali
Установить Kiali:
```
kubectl apply -f kiali
kubectl rollout status deployment/kiali -n istio-system
```

### Протестировать
Открыть сервис в браузере через istio-ingressgateway:
```
minikube -n istio-system service istio-ingressgateway
```

Поотправлять запросы на endpoint
```
<servicehost>/users
```

Посмотреть граф в Kiali
```
istioctl dashboard kiali
```

### Карта сервисов
![Map](screenshot.png)