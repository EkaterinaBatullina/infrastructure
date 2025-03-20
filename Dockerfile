FROM openjdk:21-jdk-slim

RUN apt-get update && apt-get install -y git

COPY target/Agona-05-1.0-SNAPSHOT.jar /app/Agona-05.jar

CMD ["java", "-jar", "/app/Agona-05.jar"]

EXPOSE 8080
