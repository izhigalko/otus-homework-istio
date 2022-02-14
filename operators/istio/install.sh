#/usr/bin/env bash

# We use relative script path, so we set proper directory first
cd "$(dirname "${BASH_SOURCE[0]}")"

istioctl operator init --watchedNamespaces istio-system --operatorNamespace istio-operator

kubectl apply -f ../../istio/istio-manifest.yaml

kubectl get all -n istio-system -l istio.io/rev=default

kubectl apply -f ../../istio/defaults.yaml
