eval $(minikube -p minikube docker-env)
docker build . -t helloworldapp