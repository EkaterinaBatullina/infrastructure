FROM openjdk:21-slim

WORKDIR /app

COPY Agona-05/target/*.jar app.jar

ENTRYPOINT ["java", "-jar", "/app/app.jar"]