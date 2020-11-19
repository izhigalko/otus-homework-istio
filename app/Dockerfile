FROM  openjdk:13-alpine
ARG WORKDIR="/usr/local/bin/SimpleApp"
ARG APP_VERSION
ENV APP_VERSION=${APP_VERSION}
WORKDIR $WORKDIR
COPY src/ru/geracimov/otus/architect/hw4/SimpleApp.java $WORKDIR
EXPOSE 8080
CMD ["java", "SimpleApp.java"]