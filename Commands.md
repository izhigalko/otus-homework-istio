```bash
Create
istioctl manifest apply -f istio/istio-manifest.yaml

Delete
istioctl manifest generate -f istio-manifest.yaml | kubectl delete -f -
manually delete namespace


kubectl get po  echoserver-56cf58b59-cdt4h -o yaml > /vagrant/echoservice-pod.yaml
sudo docker ps | grep echoser

find PID: sudo docker inspect <CONTAINER_ID> | less
ps ax | grep <PID>

sudo nsenter -t <PID> iptables -t nat -L
sudo nsenter -t 6905 -n iptables -t nat -S




http://127.0.0.1:32080
http://127.0.0.1:32081/?url=http://echoserver.default


kubectl apply -f manage-traffic/proxy-app-sidecar-disable.yaml
kubectl apply -f manage-traffic/proxy-app-sidecar-enable.yaml



kubectl exec proxy-app-6c579dc8dd-8qmps -c istio-proxy curl http://127.0.0.1:15000/config_dump >  /vagrant/proxy-app-config.yaml

------ 3

kubectl apply -f proxy-config/inbound-http-metrics.yaml

istio enable telemetry with istio manifest


istioctl install --set values.kiali.enabled=true
kubectl -n istio-system get svc kiali

```