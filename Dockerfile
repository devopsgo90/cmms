# --- Build Frontend ---
FROM node:20 AS build-frontend
WORKDIR /frontend
COPY frontend/package*.json ./
RUN npm install
COPY frontend .
RUN npm run build

# --- Build Backend ---
FROM openjdk:17-jdk-slim
WORKDIR /app
COPY api/ /app/
RUN ./gradlew build -x test || true

# --- Final Image ---
WORKDIR /app
COPY --from=build-frontend /frontend/build ./public
EXPOSE 8080
CMD ["java", "-jar", "build/libs/atlas-cmms.jar"]
