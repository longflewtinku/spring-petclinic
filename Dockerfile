FROM maven:4.0.0-rc-5-eclipse-temurin-25-alpine AS build 
ADD . /app 
WORKDIR /app 
RUN mvn package 

FROM eclipse-temurin:25-noble AS runtime 
LABEL project=spc
LABEL author=devopsteam 
RUN useradd -m -d /java -s /bin/bash devops 
WORKDIR /java 
COPY --from=build /app/target/*.jar laxmikanth.jar 
EXPOSE 8080
CMD ["java", "-jar", "laxmikanth.jar"]