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
                FROM maven:3.9.12-eclipse-temurin-25 AS build
                ADD . /app
                WORKDIR /app
                RUN mvn clean package -DskipTests

                FROM eclipse-temurin:25
                COPY --from=build /app/target/*.jar /devops/karthik.jar
                WORKDIR /devops
                EXPOSE 8080
                CMD ["java","-jar","karthik.jar"]
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
