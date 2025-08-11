FROM maven:3.9.11-eclipse-temurin-17 AS build
RUN git clone https://github.com/longflewtinku/spring-petclinic.git && \
    cd spring-petclinic && \
    mvn package 

FROM amazoncorretto:17 AS runtime
RUN adduser -D -h /usr/share/demo -s /bin/bash testuser
USER testuser
WORKDIR /usr/share/demo
COPY --from=build /target/*.jar laxmikanth.jar
EXPOSE 8080/tcp
CMD ["java", "-jar", "laxmikanth.jar"]