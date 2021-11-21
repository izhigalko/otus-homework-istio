#!/bin/bash

ISTIO_GW_HOST=$(minikube ip)
ISTIO_GW_PORT=$(kubectl -n istio-system get service istio-ingressgateway -o jsonpath='{.spec.ports[?(@.name=="http2")].nodePort}')

while true; do
    # make 20 requests with curl
    curl http://$ISTIO_GW_HOST:$ISTIO_GW_PORT?[1-20]
    sleep 3
done
