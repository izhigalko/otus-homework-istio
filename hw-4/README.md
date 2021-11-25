# Otus.Project
📚 Homework(s) in scope of a course ["Microservice Architecture"](https://otus.ru/lessons/microservice-architecture/)

---

How to run hw #4:
```console
cd hw-4/
# install istio
istioctl install --set profile=demo -y
# install prometheus
kubectl apply -f https://raw.githubusercontent.com/istio/istio/release-1.12/samples/addons/prometheus.yaml
# install kiali
kubectl apply -f https://raw.githubusercontent.com/istio/istio/release-1.12/samples/addons/kiali.yaml
# enable istio sidecar injection for default ns
kubectl label namespace default istio-injection=enabled
# install test-api
kubectl apply -f test-api/two_versions_of_api.yaml
# install istio-gateway
kubectl apply -f istio-gateway/manifest.yaml
# run kiali dashboard
istioctl dashboard kiali
```

How to test hw #4:
```console
# run a simple load test
ab -n 500 -c 2 localhost/health

# remove all the resources
kubectl delete -f test-api/two_versions_of_api.yaml
kubectl delete -f istio-gateway/manifest.yaml
kubectl delete -f https://raw.githubusercontent.com/istio/istio/release-1.12/samples/addons/prometheus.yaml
kubectl delete -f https://raw.githubusercontent.com/istio/istio/release-1.12/samples/addons/kiali.yaml
istioctl x uninstall --purge
kubectl delete namespace istio-system
```