FROM alpine:3.14
EXPOSE 8000
WORKDIR /www
RUN apk update
RUN apk add openjdk11
RUN apk add git && git clone https://github.com/ATer-Oganisyan/otus-demo-istio.git && cd otus-demo-istio/app && javac App.java && apk del git && rm App.java
ENTRYPOINT java -classpath /www/otus-demo-istio/app App  "v3.2"