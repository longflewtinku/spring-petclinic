pipeline {
    agent { label 'SPC' }

    parameters {
        choice(name: 'goals', choices: ['package', 'clean install', 'verify'], description: 'Pick something')
    }

    stages {

        stage('git checkout') {
            steps {
                git url: 'https://github.com/longflewtinku/spring-petclinic.git', branch: 'main'
            }
        }

        // stage('build and scan') {
        //     steps {
        //         withCredentials([string(credentialsId: 'sonar_id', variable: 'SONAR_TOKEN')]) {
        //             withSonarQubeEnv('SONAR') {
        //                 sh """
        //                 mvn ${params.goals} sonar:sonar \
        //                 -Dsonar.projectKey=longflewtinku_spring-petclinic \
        //                 -Dsonar.organization=longflewtinku \
        //                 -Dsonar.host.url=https://sonarcloud.io/ \
        //                 -Dsonar.login=$SONAR_TOKEN
        //                 """
        //             }
        //         }
        //     }
        // }

        // stage('Binary file store') {
        //     steps {
        //         rtUpload(
        //             serverId: 'JFROG',
        //             spec: '''{
        //                 "files": [
        //                     {
        //                         "pattern": "target/*.jar",
        //                         "target": "spcjava-spc/"
        //                     }
        //                 ]
        //             }'''
        //         )

        //         rtPublishBuildInfo(serverId: 'JFROG')
        //     }
        // }

        stage('docker image push to ecr nad pulling from dockerhub') {
            steps {
                sh """docker image pull nginx:1.29,
                      aws ecr get-login-password --region us-west-2 | docker login --username AWS --password-stdin 741907363630.dkr.ecr.us-west-2.amazonaws.com,
                      docker tag nginx:1.29 741907363630.dkr.ecr.us-west-2.amazonaws.com/dev/spcimage:latest,
                      docker push 741907363630.dkr.ecr.us-west-2.amazonaws.com/dev/spcimage:latest"""
            }
        }

    }
}