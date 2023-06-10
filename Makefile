docker-build:
	docker build --platform linux/amd64 -t docker.io/amburskui/echoserver:v0.1 app/src
	docker tag docker.io/amburskui/echoserver:v0.1 docker.io/amburskui/echoserver:v0.2

docker-push:
	docker push docker.io/amburskui/echoserver:v0.1
	docker push docker.io/amburskui/echoserver:v0.2

install-kiali:
	helm repo add kiali https://kiali.org/helm-charts
	helm repo update
	
	helm install \
		--set cr.create=true \
		--set cr.namespace=istio-system \
		--namespace kiali-operator \
		--create-namespace \
		kiali-operator \
		kiali/kiali-operator

	kubectl port-forward svc/kiali 20001:20001 -n istio-system

install-istio:
	helm repo add istio https://istio-release.storage.googleapis.com/charts
	helm repo update

	kubectl create namespace istio-system
	helm install istio-base istio/base -n istio-system
	helm install istiod istio/istiod -n istio-system --wait

	kubectl create namespace istio-ingress
	helm install istio-ingress istio/gateway -n istio-ingress --wait

	kubectl apply -f https://raw.githubusercontent.com/istio/istio/release-1.18/samples/addons/prometheus.yaml

	kubectl get namespace -L istio-injection