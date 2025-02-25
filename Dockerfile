FROM maven:3.8.5-openjdk-17 AS builder

WORKDIR /app

COPY pom.xml .
RUN mvn dependency:go-offline -B

COPY src ./src

RUN mvn clean package -DskipTests
FROM tomcat:9.0 AS runtime
RUN rm -rf /usr/local/tomcat/webapps/ROOT

COPY --from=builder /app/target/*.war /usr/local/tomcat/webapps/ROOT.war
# Expose port 8080
EXPOSE 8080
# Start Tomcat
CMD ["catalina.sh", "run"]

