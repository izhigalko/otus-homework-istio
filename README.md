```
istioctl install
```
```
helm install \
    --set cr.create=true \
    --set cr.namespace=istio-system \
    --namespace kiali-operator \
    --create-namespace \
    kiali-operator \
    kiali/kiali-operator
```
```
 kubectl apply -f namespace.yaml
```
```
kubectl apply -f https://raw.githubusercontent.com/istio/istio/release-1.18/samples/addons/prometheus.yaml
```
```
kubectl apply -f disable_mtls.yaml
```
```
helm install hw5 homework-5/
```
