def call() {
    pipeline {
    agent { label 'OPENJDK-11-JDK' }
    stages {
        stage('vcs') {
            steps {
                git url: 'https://github.com/longflewtinku/spring-petclinic.git', 
                    branch: 'main'
            }
        }    
        stage('Example Build') {
            steps {
                sh '/usr/share/maven/bin/mvn package'   
            }
        }
        stage('Junit Results'){
            steps {
                junit '**/*.xml'
            }
        }
      }
   }
}