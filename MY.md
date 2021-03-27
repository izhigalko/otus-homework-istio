minikube start --cpus=4 --memory=8g --cni=flannel --kubernetes-version="1.19.0" --extra-config=apiserver.enable-admission-plugins=NamespaceLifecycle,LimitRanger,ServiceAccount,DefaultStorageClass,DefaultTolerationSeconds,NodeRestriction,MutatingAdmissionWebhook,ValidatingAdmissionWebhook,ResourceQuota,PodPreset --extra-config=apiserver.authorization-mode=Node,RBAC

### jaeger
helm repo add jaegertracing https://jaegertracing.github.io/helm-charts
helm install --version "2.19.0" -n jaeger-operator jaeger-operator jaegertracing/jaeger-operator  -f .\jaeger\values.yaml
kubectl apply -f .\jaeger\jaeger.yaml

#app
kubectl apply -f .\app\app.yaml

### prometheus
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo add stable https://kubernetes-charts.storage.googleapis.com/
helm install --version "13.7.2" -n prometheus prometheus prometheus-community/kube-prometheus-stack -f .\prometheus\values.yaml 
kubectl apply -f .\prometheus\prometheus.yaml (not necessary)

### istio
istioctl operator init
kubectl apply -f .\istio\istio.yaml
kubectl apply -f .\istio\ingress.yaml

### kiali
helm repo add kiali https://kiali.org/helm-charts
helm install --version "1.29.1" -n kiali-operator kiali-operator kiali/kiali-operator
kubectl apply -f .\kiali\kiali.yaml


