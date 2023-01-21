Разворачиваем две версии приложения echoserver:
kubectl apply -f app/echoserver.yaml

Создаём нагрузку:
kubectl apply -f app/load.yaml

Результат:
kiali-graph.png