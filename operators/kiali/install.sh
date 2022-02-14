#/usr/bin/env bash

# We use relative script path, so we set proper directory first
cd "$(dirname "${BASH_SOURCE[0]}")"

echo "Adding kiali helm chart repo"
helm repo add kiali https://kiali.org/helm-charts
helm repo update

IS_INSTALLED="$(helm list -n kiali-operator | grep kiali-operator)"
if [[ -n "$IS_INSTALLED" ]]; then
	echo 'kiali-operator is already installed, skipping';
else \
	echo 'Installing kiali-operator with helm';
	helm install --version "1.33.1" -n kiali-operator -f operator-values.yaml kiali-operator kiali/kiali-operator
fi

kubectl apply -f kiali.yaml

kubectl get po -n kiali -l app.kubernetes.io/name=kiali
