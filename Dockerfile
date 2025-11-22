# Etap 1 – build aplikacji
FROM maven:3.9-eclipse-temurin-17 AS build
WORKDIR /app

# Najpierw kopiujemy sam pom.xml (lepszy cache)
COPY pom.xml .
RUN mvn -q -DskipTests dependency:go-offline

# Potem resztę kodu
COPY src ./src

# Budujemy JAR
RUN mvn -q -DskipTests package

# Etap 2 – lekkie image do uruchomienia
FROM eclipse-temurin:17-jre-alpine
WORKDIR /app

# Kopiujemy zbudowany JAR z poprzedniego etapu
COPY --from=build /app/target/*.jar app.jar

EXPOSE 8080

ENTRYPOINT ["java","-jar","/app/app.jar"]
