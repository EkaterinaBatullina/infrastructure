# Используем образ OpenJDK для работы с Java
FROM openjdk:21-slim

WORKDIR /app

COPY target/*.jar app.jar

ENTRYPOINT ["java", "-jar", "/app/app.jar"]