# Etapa 1: compilar con Maven + Java 8
FROM maven:3.8.8-eclipse-temurin-8 AS build
WORKDIR /app
COPY SaludBoyaca/ .
RUN mvn clean package -DskipTests

# Etapa 2: ejecutar en Tomcat 9 + Java 8
FROM tomcat:9.0-jdk8-temurin
RUN rm -rf /usr/local/tomcat/webapps/*
COPY --from=build /app/target/SaludBoyaca.war /usr/local/tomcat/webapps/ROOT.war
EXPOSE 8080
CMD ["catalina.sh", "run"]