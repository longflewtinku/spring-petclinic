pipeline {
    agent {label 'SPC'}
    triggers {
        pollSCM('* * * * *')
    }
    stages {
        stage('git checkout') {
            steps {
                git url: 'https://github.com/longflewtinku/spring-petclinic.git',
                    branch: 'main' 
            }
        }
        stage('build and scan') {
            steps {
             withCredentials([string(credentialsId: 'sonar_id', variable: 'SONAR_TOKEN')]) {   
             withSonarQubeEnv('SONAR') {   
                sh """mvn package sonar:sonar \
                      -Dsonar.projectKey=longflewtinku_spring-petclinic \
                      -Dsonar.organization=longflewtinku \
                      -Dsonar.host.url=https://sonarcloud.io/ \
                      -Dsonar.login=$SONAR_TOKEN""" 
            }
          }  
        }
     } 
     stage('Binary file store') {
        steps {
        rtupload (
            serverId: 'JFROG',
            spec: '''{
                "files": [
                    {
                    "pattern": "target/*.jar",
                    "target": "spcjava-spc/"
                    }
                ]
                }'''

    )
     rtPublishBuildInfo(serverId: 'JFROG') 
     }
    }  
  }
}