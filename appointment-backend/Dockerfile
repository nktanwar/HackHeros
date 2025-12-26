# ---------- BUILD STAGE ----------
FROM gradle:8.6-jdk17 AS builder

WORKDIR /app

COPY gradle gradle
COPY build.gradle.kts settings.gradle.kts ./
COPY src src

RUN gradle clean bootJar --no-daemon


# ---------- RUNTIME STAGE ----------
FROM eclipse-temurin:17-jre-alpine

WORKDIR /app

COPY --from=builder /app/build/libs/*.jar app.jar

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "app.jar"]
