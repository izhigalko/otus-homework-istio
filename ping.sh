#/bin/bash

while [ 1 = 1 ]
do
curl -HHost:echoserver.com "http://$INGRESS_HOST:$INGRESS_PORT/?url=http://proxy-app" > /dev/null
curl -HHost:echoserver.com "http://$INGRESS_HOST:$INGRESS_PORT/?url=http://echoserver.com" > /dev/null
#curl -HHost:echoserver.com "http://$INGRESS_HOST:$INGRESS_PORT/?url=http://echoserver" > /dev/null
curl -HHost:echoserver.com "http://$INGRESS_HOST:$INGRESS_PORT/" > /dev/null
#curl $(minikube ip):32080/?url=http://proxy-app > /dev/null
#curl $(minikube ip):32081/?url=http://proxy-app > /dev/null
#curl $(minikube ip):32080/?url=http://echoserver > /dev/null
#curl $(minikube ip):32081/?url=http://echoserver > /dev/null
done