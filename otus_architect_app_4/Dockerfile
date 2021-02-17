FROM maven:latest as builder
LABEL maintainer="Dubinina Yulia"
RUN mkdir /app
WORKDIR /app
COPY . .
RUN mvn clean package


######## Start a new stage #######
FROM openjdk:8  
RUN mkdir /app
WORKDIR /app
COPY --from=builder /app/target/otus_architect_app_4-0.0.1-SNAPSHOT.jar .
EXPOSE 8080 
ENTRYPOINT ["java", "-jar", "otus_architect_app_4-0.0.1-SNAPSHOT.jar"]