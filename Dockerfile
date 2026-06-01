# Build stage
FROM maven:3.8.1-openjdk-8 AS builder
WORKDIR /app
COPY pom.xml .
COPY src ./src
RUN mvn clean package -DskipTests

# Runtime stage
FROM tomcat:8.5-jre8-alpine
WORKDIR /usr/local/tomcat
RUN rm -rf webapps/ROOT
COPY --from=builder /app/target/*.war webapps/ROOT.war
EXPOSE 8080
CMD ["catalina.sh", "run"]
