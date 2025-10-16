# Use JDK base image
FROM openjdk:17-jdk-slim

# Set working directory
WORKDIR /app

# Copy the JAR file built by Maven
COPY target/*.jar app.jar

EXPOSE 8761
# Run the application
ENTRYPOINT ["java", "-jar", "app.jar"]
