pipeline {
  agent {
    label 'JDKJAVASPC'

  }   
  stages {
    stage('GIT CHECKOUT') {
      steps {
        git url: 'https://github.com/longflewtinku/spring-petclinic.git',
        branch: 'main'
      }
    }
    stage('build and scan') {
      steps {
        withCredentials([string(credentialsId: 'sonar_id', variable: 'SONAR_TOKEN')]) {
                    withSonarQubeEnv('SONARQUBE') {
                        sh '''
                            mvn package sonar:sonar \
                            -Dsonar.projectKey=longflewtinku_spring-petclinic \
                            -Dsonar.organization=jenkinsjava \
                            -Dsonar.host.url=https://sonarcloud.io \
                            -Dsonar.login=$SONAR_TOKEN
                        '''
               }
            }
         }
      }
      stage('upload jfrog') {
        steps {
          rtupload (
            serverId: 'JFROG_SPC_JAVA',
            spec: ''' {
               "files": [
                  {
                    "pattern": "target/*.jar",
                    "target": "jfrogjavaspc-libs-release/"
                  }
                ]
            } ''',
          )
          rtPublishBuildInfo (
            serverId: 'JFROG_SPC_JAVA'
          )
        }
      }
post {
        always {
            archiveArtifacts artifacts: '**/target/*.jar'
            junit '**/target/surefire-reports/*.xml' 
        }
        success {
            echo 'this pipeline good'
        }
        failure {
            echo 'this is waste pipeline'
        }
    }
  }
}