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
              withSonarQubeEnv('SONAR') {
                sh "mvn package sonar:sonar"
              } 
            }
        }
    }
}







