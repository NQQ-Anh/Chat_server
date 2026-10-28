FROM maven:3.9-eclipse-temurin-17 AS build

WORKDIR /app
COPY pom.xml .
COPY src ./src
RUN mvn -B package

FROM eclipse-temurin:17-jre-jammy

WORKDIR /app
RUN useradd --system --uid 10001 --create-home app \
    && mkdir -p /var/data/uploads \
    && chown -R app:app /var/data
COPY --from=build --chown=app:app /app/target/chat-platform-server-1.0.0.jar app.jar

ENV CHAT_UPLOAD_DIR=/var/data/uploads
EXPOSE 8080
USER app

ENTRYPOINT ["java", "-jar", "/app/app.jar"]
