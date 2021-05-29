```shell
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update

helm install -n monitoring -f monitoring/values.yaml prometheus \
prometheus-community/kube-prometheus-stack

kubectl apply -f monitoring/nodeport.yaml -n monitoring
```
