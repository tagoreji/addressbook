<<<<<<< HEAD
FROM tomcat:8.5.72-jdk8-openjdk-buster
ENV MAVEN_HOME /usr/share/maven
ENV MAVEN_VERSION 3.8.4

RUN  apt-get update && \
    apt-get install -y curl && \
    curl -fsSL https://archive.apache.org/dist/maven/maven-3/$MAVEN_VERSION/binaries/apache-maven-$MAVEN_VERSION-bin.tar.gz | tar xzf - -C /usr/share && \
    mv /usr/share/apache-maven-$MAVEN_VERSION /usr/share/maven && \
    ln -s /usr/share/maven/bin/mvn /usr/bin/mvn && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY ./src ./src
COPY ./pom.xml ./pom.xml

run mvn package

Run rm -rf /usr/local/tomcat/webapps/*

RUN cp /app/target/addressbook.war /usr/local/tomcat/webapps/

Expose 8080

=======
# Stage 1: Build stage
FROM maven:3.8.4-openjdk-11-slim AS build-stage


# Set the working directory inside the container
WORKDIR /app


# Copy the Maven project definition files
COPY pom.xml ./


# Download the dependencies needed for the build (cache them in a separate layer)
RUN mvn dependency:go-offline


# Copy the application source code
COPY src ./src


# Build the WAR file
RUN mvn package


# Stage 2: Production stage
FROM tomcat:8.5.78-jdk11-openjdk-slim


# Copy the built WAR file from the build stage to the Tomcat webapps directory
COPY --from=build-stage /app/target/*.war /usr/local/tomcat/webapps/


# Expose the port on which Tomcat will listen (usually port 8080)
EXPOSE 8080


# Start Tomcat
>>>>>>> 2104160 (docker stage)
CMD ["catalina.sh", "run"]
