FROM openjdk:21-slim

WORKDIR /app

COPY target/Agona-05-1.0-SNAPSHOT-jar-with-dependencies.jar app.jar

ENTRYPOINT ["java", "-jar", "/app/app.jar"]