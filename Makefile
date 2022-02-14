KUBERNETES_VERSION := v1.19.0

all: install_operators build_app deploy_app

.PHONY: minikube
minikube:
	@# --vm-driver=hyperkit: Docker driver is used by default, provides bad network
	@# --cni=flannel: Docker bridge is used by default, also not nice.
	minikube start \
	--vm-driver=hyperkit \
	--cni=flannel \
	--cpus=2 --memory=8g \
	--kubernetes-version=$(KUBERNETES_VERSION) \
	&& minikube addons enable ingress

.PHONY: namespaces
namespaces:
	kubectl apply -f operators/namespaces.yaml

.PHONY: jaeger
jaeger:
	@operators/jaeger/install.sh

.PHONY: prometheus
prometheus:
	@operators/prometheus/install.sh

.PHONY: istio
istio:
	@operators/istio/install.sh

.PHONY: kiali
kiali:
	@operators/kiali/install.sh

.PHONY: install_operators
install_operators: namespaces jaeger prometheus istio kiali

.PHONY: build_app
build_app:
	@app/build.sh

.PHONY: deploy_app
deploy_app:
	kubectl apply -f app
