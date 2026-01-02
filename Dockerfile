FROM maven:3.9.12-eclipse-temurin-25 AS build
ADD . /app
WORKDIR /app
RUN mvn package

FROM eclipse-temurin:25 
LABEL project="springpetclinic"
LABEL name="javaapplication"
COPY --from=build /app/target/*.jar /devops/karthik.jar
WORKDIR /devops
EXPOSE 8080
CMD [ "java","-jar","karthik.jar" ]