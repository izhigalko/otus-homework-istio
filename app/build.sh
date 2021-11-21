#!/bin/bash

eval $(minikube docker-env) && docker build -t echoserver:latest -f app/src/Dockerfile app/src