#!/bin/bash

# Receive service url
SERVICE_URL=$(minikube service microservices-arch-service --url -n microservices-arch-istio)

# Check the service is working
for i in {1..20} ; do
    curl ${SERVICE_URL}/
    echo
done