#/usr/bin/env bash

# We use relative script path, so we set proper directory first
cd "$(dirname "${BASH_SOURCE[0]}")"

echo "Adding prometheus-community helm chart repo"
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo add stable https://charts.helm.sh/stable
helm repo update

IS_INSTALLED="$(helm list -n monitoring | grep prometheus)"
if [[ -n "$IS_INSTALLED" ]]; then
	echo 'Upgraging prometheus release with helm';
	helm upgrade -n monitoring --version "13.7.2" -f ./operator-values.yaml prometheus prometheus-community/kube-prometheus-stack
else \
	echo 'Installing prometheus release with helm';
	helm install -n monitoring --version "21.0.0" -f ./operator-values.yaml prometheus prometheus-community/kube-prometheus-stack
fi

kubectl get po -n monitoring
