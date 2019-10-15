FROM maven:3-jdk-10
LABEL maintainer="Markus Esch <markus.esch@htwsaar.de>"

# Variables
ENV APP_JAR_NAME augmented-backend-1.0.jar

WORKDIR /usr/src/app
COPY . .
RUN mvn -B -f pom.xml -s /usr/share/maven/ref/settings-docker.xml package
RUN cp target/${APP_JAR_NAME} ./app.jar

# Package
FROM openjdk:11-stretch
RUN mkdir /app
WORKDIR /app
COPY --from=0 /usr/src/app/app.jar ./app.jar

CMD ["java", "-jar", "/app/app.jar"]
