#!/bin/bash

# create namespace
kubectl apply -f namespace.yaml

# enable istio sidecar injection to new namespace
kubectl label namespace microservices-arch-istio istio-injection=enabled

# enable prometheus
kubectl apply -f https://raw.githubusercontent.com/istio/istio/release-1.12/samples/addons/prometheus.yaml

# enable kiali
kubectl apply -f https://raw.githubusercontent.com/istio/istio/release-1.12/samples/addons/kiali.yaml

# apply istio yaml files
kubectl apply -f ./istio/ -n microservices-arch-istio

# apply application yaml files
kubectl apply -f ./k8s/ -n microservices-arch-istio