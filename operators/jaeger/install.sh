#/usr/bin/env bash

# We use relative script path, so we set proper directory first
cd "$(dirname "${BASH_SOURCE[0]}")"


IS_INSTALLED="$(helm list -n jaeger-operator | grep jaeger-operator)"
if [[ -n "$IS_INSTALLED" ]]; then
	echo 'jaeger-operator is already installed, skipping';
else
	echo "Adding jaegertracing helm chart repo"
	helm repo add jaegertracing https://jaegertracing.github.io/helm-charts
	helm repo update
	echo 'Installing jaeger-operator with helm';
	helm install --version "2.19.0" -n jaeger-operator -f operator-values.yaml jaeger-operator jaegertracing/jaeger-operator
fi

kubectl apply -f jaeger.yaml

kubectl get po -n jaeger -l app.kubernetes.io/instance=jaeger
