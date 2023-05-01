## Выполнение домашнего задания


Для настройки окружения выполнить команды из демо: 

- https://github.com/izhigalko/otus-demo-istio

### Запуск сервиса
```
make health
make balancing
```

### Нагрузка на сервис
```
kubectl get service/istio-ingressgateway -n istio-system

нужен порт 80:32035/TCP

ab -n 1000 -c 10 http://192.168.49.2:32035/health/
```

### График в Kiali
```
minikube service -n istio-system kiali
```

![Alt text](./istio-kiali.jpg?raw=true "")
