#/usr/bin/env bash

# We use relative script path, so we set proper directory first
cd "$(dirname "${BASH_SOURCE[0]}")"

eval $(minikube docker-env) && docker build -t echoserver:latest -f src/Dockerfile src
