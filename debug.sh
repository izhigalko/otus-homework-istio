#!/bin/sh
eval $(minikube docker-env)
# cd ./app/src
# docker build -t proxy-app:v1 .
docker build -t proxy-app:latest -f app/src/Dockerfile app/src

