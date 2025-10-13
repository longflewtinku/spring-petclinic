# FROM maven:3.9.11-eclipse-temurin-17 AS build
# RUN git clone https://github.com/spring-projects/spring-petclinic.git && \
#     cd spring-petclinic && \
#     mvn package 

# FROM eclipse-temurin:17.0.16_8-jre-ubi9-minimal AS runtime
# RUN adduser -m -d  /usr/share/demo -s /bin/bash testuser
# USER testuser
# WORKDIR /usr/share/demo
# COPY --from=build /spring-petclinic/target/*.jar laxmikanth.jar
# EXPOSE 8080/tcp
# CMD ["java", "-jar", "laxmikanth.jar"]


FROM openjdk:17 
ADD https://trial2rt5pi.jfrog.io/ui/native/jfrogjavaspc-libs-release/spring-petclinic-3.5.0-SNAPSHOT.jar  laxmikanth.jar 
EXPOSE 8080
CMD ["java", "-jar", "laxmikanth.jar"]