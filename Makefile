DOCKER_IMG="astrviktor/health:2.0.0"

GIT_HASH := $(shell git log --format="%h" -n 1)
LDFLAGS := -X main.release="develop" -X main.buildDate=$(shell date -u +%Y-%m-%dT%H:%M:%S) -X main.gitHash=$(GIT_HASH)

docker-build:
	docker build \
		--build-arg=LDFLAGS="$(LDFLAGS)" \
		--platform linux/amd64 \
		-t $(DOCKER_IMG) \
		-f docker/Dockerfile .

docker-push:
	docker push $(DOCKER_IMG)

# Команды из демо https://github.com/izhigalko/otus-demo-istio

minikube:
	#Запустить minikube
	@minikube start --driver virtualbox --cpus=4 --memory=12g --cni=flannel --kubernetes-version="v1.19.0"

namespaces:
	#Создать неймспейсы для операторов:
	@kubectl apply -f ./manifests/namespaces.yaml

jaeger:
	#Разворачиваем Jaeger

	#Jaeger - решение трассировки.
	#Компоненты Istio, такие как: sidecar-контейнер, gateway, отправляют данные запросов в систему.
	#Таким образом получается полная трассировка запроса.

	#Добавить репозиторий в Helm:
	@helm repo add jaegertracing https://jaegertracing.github.io/helm-charts
	@helm repo update

	#Установить оператор, разворачивающий Jaeger:
	@helm install --version "2.19.0" -n jaeger-operator -f ./manifests/jaeger/operator-values.yaml jaeger-operator jaegertracing/jaeger-operator --wait

	#Развернуть Jaeger:
	@kubectl apply -f ./manifests/jaeger/jaeger.yaml

	#Проверить состояние Jaeger:
	@kubectl get po -n jaeger -l app.kubernetes.io/instance=jaeger

	#Открыть web-интерфейс Jaeger:
	@minikube service -n jaeger jaeger-query-nodeport

prometheus:
	#Разворачиваем Prometheus

	#Prometheus - система мониторинга. С помощью неё собираются метрики Service mesh.

	#Prometheus - система мониторинга. С помощью неё собираются метрики Service mesh.
	#Добавить репозиторий в Helm:
	@helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
	@helm repo add stable https://charts.helm.sh/stable
	@helm repo update

	#Развернуть решение по мониторингу на основе Prometheus:
	@helm install --version "13.7.2" -n monitoring -f ./manifests/prometheus/operator-values.yaml prometheus prometheus-community/kube-prometheus-stack --wait

	#Проверить состояние компонентов мониторинга:
	@kubectl get po -n monitoring

	#Добавить сервис типа NodePort для прямого доступа к Prometheus и Grafana:
	@kubectl apply -f ./manifests/prometheus/monitoring-nodeport.yaml

	#Открыть web-интерфейс Grafana:
	@minikube service -n monitoring prometheus-grafana-nodeport

	#Открыть web-интерфейс Prometheus:
	@minikube service -n monitoring prom-prometheus-nodeport

istio:
	#Разворачиваем Istio

	#Istio - Service mesh решение для облачных платформ, использующее Envoy.

	#Установить оператор, разворачивающий Istio:
	@istioctl operator init --watchedNamespaces istio-system --operatorNamespace istio-operator

	#Развернуть Istio c помощью оператора:
	@kubectl apply -f ./manifests/istio/istio.yaml

	#Проверить состояние Istio:
	@kubectl get all -n istio-system -l istio.io/rev=default

	#Установить настройки по-умолчанию:
	@kubectl apply -f ./manifests/istio/disable-mtls.yaml

kiali:
	#Устанавливаем Kiali

	#Kiali - доска управления Service mesh

	#Добавить репозиторий в Helm:
	@helm repo add kiali https://kiali.org/helm-charts
	@helm repo update

	#Установить Kiali Operator, разворачивающий Kiali
	@helm install --version "1.33.1" -n kiali-operator -f ./manifests/kiali/operator-values.yaml kiali-operator kiali/kiali-operator --wait

	#Развернуть Kiali:
	@kubectl apply -f ./manifests/kiali/kiali.yaml

	#Проверить состояние Kiali:
	@kubectl get po -n kiali -l app.kubernetes.io/name=kiali

	#Открыть web-интерфейс Kiali:
	@minikube service -n kiali kiali-nodeport

health:
	#Устанавливаем app Health

	#Health - простое приложение которое на запрос curl --request GET 'http://127.0.0.1:8000/health/'
	#отвечает:
	#версия 1.0.0 - {"status":"OK"}
	#версия 2.0.0 - {"status":"OK","host":"127.0.0.1","port":"48968"}

	#Создать неймспейс:
	@kubectl apply -f ./manifests/app/namespace.yaml

	#Развернуть Health:
	@kubectl apply -f ./manifests/app/deployment-v1.yaml
	@kubectl apply -f ./manifests/app/deployment-v2.yaml
	@kubectl apply -f ./manifests/app/service.yaml

	#Проверить поды
	#должно быть по 2 экземпляра 2/2 - 1 приложение, 2 sidecar
	@kubectl get pods -n health

	#Открыть Health в браузере:
	#@minikube service -n application health-service

balancing:
	#Настройка балансировки для Health

	@kubectl apply -f ./manifests/balancing/destinationrule.yaml
	@kubectl apply -f ./manifests/balancing/virtualservice.yaml
	@kubectl apply -f ./manifests/balancing/gateway.yaml

testing:
	#kubectl get service/istio-ingressgateway -n istio-system
	#нужен порт 80:32035/TCP
	ab -n 1000 -c 10 http://192.168.49.2:32035/health/
