kube:
	@minikube start --driver virtualbox --cpus=4 --memory=8g --cni=flannel --kubernetes-version="v1.19.0"
istio-install:
	@istioctl operator init --watchedNamespaces istio-system --operatorNamespace istio-operator
	@kubectl apply -f istio/istio-manifest.yaml
	@kubectl apply -f istio/defaults.yaml

kiali-install:
	@helm repo add kiali https://kiali.org/helm-charts
	@helm repo update
	@helm install --version "1.33.1" -n kiali-operator -f manifests/kiali/operator-values.yaml kiali-operator kiali/kiali-operator
	@kubectl apply -f manifests/kiali/kiali.yaml

prometheus:
	@kubectl apply -f manifests/prometheus/namespace.yaml
	@helm install --version "13.7.2" -n monitoring -f manifests/prometheus/operator-values.yaml prometheus prometheus-community/kube-prometheus-stack

kiali-web:
	@minikube service -n kiali kiali-nodeport

app_forward:
	@kubectl port-forward service/otus-5-service 8080:8000