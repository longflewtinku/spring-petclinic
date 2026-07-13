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
    //     stage('scan') {
    //         steps  {
    //          withCredentials([string(credentialsId: 'soanr_id', variable: 'SONAR_TOKEN')]) {   
    //           withSonarQubeEnv('SONAR') {
    //             sh """mvn clean verify sonar:sonar \
    //                   -Dsonar.projectKey=longflewtinku_spring-petclinic \
    //                   -Dsonar.organization=longflewtinku-2 \
    //                   -Dsonar.host.url=https://sonarcloud.io/ \
    //                   -Dsonar.login=SONAR_TOKEN""" 
                    
    //             } 
    //         }
    //     }
    // }
        // stage('upload binaryfile') {
        //     steps {
        //         rtUpload (
        //             serverId: 'JFROG_ID',
        //             spec: '''{
        //                "files": [
        //                {
        //                  "pattern": "target/*.jar",
        //                  "target": "javaspc/"
        //                } 
        //                ]
        //             }'''

        //         )
        //         rtPublishBuildInfo(serverId: 'JFROG_ID')
        //     }
        // }
        stage('dockerimage build') {
            steps {
                sh """aws ecr get-login-password --region us-west-2 | docker login --username AWS --password-stdin 984912521466.dkr.ecr.us-west-2.amazonaws.com
                      docker build -t dev/spc .
                      docker tag dev/spc:latest 984912521466.dkr.ecr.us-west-2.amazonaws.com/dev/spc:latest
                      docker push 984912521466.dkr.ecr.us-west-2.amazonaws.com/dev/spc:latest"""
            }
        }
        stage('docker image scan') {
            steps {
                sh 'trivy image  984912521466.dkr.ecr.us-west-2.amazonaws.com/dev/spc:latest'
            }
        }
        stage('deploy k8s') {
            steps {
                sh 'kubectl apply -f deployment.yaml'
            }
        }
  }
}












