# ── ETAPA 1: Compilar el proyecto con Maven ──────────────────────────────────
# Imagen que ya tiene Maven + Java 8 instalados
FROM maven:3.8.8-eclipse-temurin-8 AS build

# Carpeta de trabajo dentro del contenedor
WORKDIR /app

# Copia todo tu proyecto al contenedor
COPY . .

# Compila y genera el WAR (sin correr tests)
RUN mvn clean package -DskipTests

# ── ETAPA 2: Ejecutar la app en Tomcat ───────────────────────────────────────
# Imagen con Tomcat 9 + Java 8
FROM tomcat:9.0-jdk8-temurin

# Borra las apps de ejemplo que trae Tomcat por defecto
RUN rm -rf /usr/local/tomcat/webapps/*

# Copia el WAR generado y lo pone como app principal (ROOT = queda en /)
COPY --from=build /app/target/SaludBoyaca.war /usr/local/tomcat/webapps/ROOT.war

# Puerto que usa Tomcat
EXPOSE 8080

# Comando para arrancar Tomcat cuando Render encienda el servidor
CMD ["catalina.sh", "run"]