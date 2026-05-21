pipeline {
    agent { label 'SPCJAVA'}
    triggers {
        pollSCM('* * * * *') 
    }
    stages {
        stage('git checkout') {
            steps {
                git url: "https://github.com/longflewtinku/spring-petclinic.git",
                branch: "main"
            }
        }
        stage('scan') {
            steps  {
             withCredentials([string(credentialsId: 'soanr_id', variable: 'SONAR')]) {   
              withSonarQubeEnv('SONAR') {
                sh """mvn clean verify sonar:sonar \
                      -Dsonar.projectKey=longflewtinku_spring-petclinic \
                      -Dsonar.organization=longflewtinku-2 \
                      -Dsonar.host.url=https://sonarcloud.io/ \
                      -Dsonar.login=SONAR""" 
                    
                } 
            }
        }
    }
  }
}







