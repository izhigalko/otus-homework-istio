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

### Istion Gateway and VirtualService
Установить объекты Istio
```
kubectl apply -f .\istio\istio.yaml
```

### Kiali
Установить Operator:
```
helm install --version "1.49.0" -n kiali-operator -f ./kiali/operator-values.yaml kiali-operator kiali/kiali-operator
```

Установить Kiali:
```
kubectl apply -f ./kiali/kiali.yaml
```
