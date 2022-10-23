def call() {
    pipeline {
    agent { label 'OPENJDK-JDK' }
    stages {
        stage('learning') {
            steps {
                git url: 'https://github.com/longflewtinku/spring-petclinic.git' , 
                    branch 'main'
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