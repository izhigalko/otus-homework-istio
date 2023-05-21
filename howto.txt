1. Установить istio по инструкции с официального сайта: https://istio.io/latest/docs/setup/getting-started/
2. Обязательно установить аддоны с kiali:

$ kubectl apply -f samples/addons
$ kubectl rollout status deployment/kiali -n istio-system

3. Установить приложение через helm install app ./chart
4. Запустить тунель в minikube: minikube tunnel
5. Запустить дэшборд kiali: istioctl dashboard kiali
6. Подать нагрузку на сервис: load.cmd
