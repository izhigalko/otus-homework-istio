export INGRESS_HOST=$(kubectl -n istio-system get service istio-ingressgateway -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
export INGRESS_PORT=$(kubectl -n istio-system get service istio-ingressgateway -o jsonpath='{.spec.ports[?(@.name=="http2")].port}')
export SECURE_INGRESS_PORT=$(kubectl -n istio-system get service istio-ingressgateway -o jsonpath='{.spec.ports[?(@.name=="https")].port}')
#export INGRESS_HOST=$(minikube ip)

for ((i=1;i<=100;i++)); do sleep 1; curl -S -I -HHost:arch.homework http://$INGRESS_HOST:$INGRESS_PORT; done
