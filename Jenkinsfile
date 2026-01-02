pipeline {
    agent { label 'JAVA' }

    triggers {
        pollSCM('* * * * *')
    }

    stages {
        stage('git checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/spring-projects/spring-petclinic.git'
            }
        }

        stage('java build') {
            steps {
                sh 'mvn clean package -DskipTests'
            }
        }

        stage('sonarqube') {
            steps {
                withSonarQubeEnv('SONARQUBE') {
                    sh '''
                        mvn org.sonarsource.scanner.maven:sonar-maven-plugin:3.9.1.2184:sonar \
                        -Dsonar.projectName=spring-petclinic \
                        -Dsonar.projectKey=karthik23081998_spring-petclinic \
                        -Dsonar.organization=karthik23081998 \
                        -Dsonar.host.url=https://sonarcloud.io \
                        -Dsonar.login=$SONAR_TOKEN
                    '''
                }
            }
        }

        // Corrected Dockerfile creation stage
        stage('create Dockerfile') {
            steps {
                sh '''
                cat <<EOF > Dockerfile
                FROM maven:3.9.12-eclipse-temurin-17 AS build
                WORKDIR /app
                COPY pom.xml .
                COPY src ./src
                RUN mvn clean package -DskipTests

                FROM eclipse-temurin:17-jre-jammy
                WORKDIR /devops
                COPY --from=build /app/target/*.jar karthik.jar
                EXPOSE 8080
                ENTRYPOINT ["java","-jar","karthik.jar"]
                EOF
                '''
            }
        }

        stage('docker build') {
            steps {
                sh '''
                    docker build -t karthik:2.0 .
                    docker image ls | grep karthik
                '''
            }
        }
    }
}
