```shell
helm repo add kiali https://kiali.org/helm-charts
helm repo update
helm install -n kiali-operator kiali-operator kiali/kiali-operator
kubectl apply -f kiali/kiali.yaml
```