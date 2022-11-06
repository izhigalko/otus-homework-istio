#!/bin/sh

kubectl delete -f namespaces.yaml 
kubectl delete -f ./istio-1.13.0/samples/addons
kubectl delete namespace istio-system
