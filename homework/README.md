# Выполнение задания
Запустить кластер в миникубе:
`minikube start --driver virtualbox --cpus=4 --memory=4200m --cni=flannel --kubernetes-version="v1.19.0"`

Установить istio:
`istoctl install --set profile=demo -y`

<!-- Установить прометеус с графаной (?):
`helm install --version "13.7.2" prometheus prometheus-community/kube-prometheus-stack` -->

Установить оператор kiali:
`helm install --version "1.33.1" kiali-operator kiali/kiali-operator`




`kubectl -n istio-system get service istio-ingressgateway -o jsonpath='{.spec.ports[?(@.name=="http2")].nodePort}'`

`minikube ip`

