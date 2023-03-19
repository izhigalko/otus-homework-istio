docker-build:
	docker build --platform linux/amd64 -t docker.io/amburskui/echoserver:v0.1 app/src
	docker build --platform linux/amd64 -t docker.io/amburskui/echoserver-load:v0.1 app/load

docker-push:
	docker push docker.io/amburskui/echoserver:v0.1
	docker tag docker.io/amburskui/echoserver:v0.1 docker.io/amburskui/echoserver:v0.2
	docker push docker.io/amburskui/echoserver:v0.2

	docker push docker.io/amburskui/echoserver-load:v0.1 
