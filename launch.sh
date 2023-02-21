#!/bin/zsh

kubectl apply -f manifest/00-namespace.yaml

helm install otus-hw04 ./app/.helm -n otus-hw04-ns

kubectl apply -f istio/ -n otus-hw04-ns