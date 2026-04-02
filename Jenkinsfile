// pipeline {
//     agent { label 'JAVA' }

//     parameters {
//         choice(name: 'goals', choices: ['package', 'clean install', 'verify'], description: 'Pick something')
//     }
//     environment {
//         image_name = 'spc'
//         tag_name = '1.0'
//     }



//     stages {

//         stage('git checkout') {
//             steps {
//                 git url: 'https://github.com/longflewtinku/spring-petclinic.git', branch: 'main'
//             }
//         }

//         // stage('build and scan') {
//         //     steps {
//         //         withCredentials([string(credentialsId: 'sonar_id', variable: 'SONAR_TOKEN')]) {
//         //             withSonarQubeEnv('SONAR') {
//         //                 sh """
//         //                 mvn ${params.goals} sonar:sonar \
//         //                 -Dsonar.projectKey=longflewtinku_spring-petclinic \
//         //                 -Dsonar.organization=longflewtinku \
//         //                 -Dsonar.host.url=https://sonarcloud.io/ \
//         //                 -Dsonar.login=$SONAR_TOKEN
//         //                 """
//         //             }
//         //         }
//         //     }
//         // }

//         // stage('Binary file store') {
//         //     steps {
//         //         rtUpload(
//         //             serverId: 'JFROG',
//         //             spec: '''{
//         //                 "files": [
//         //                     {
//         //                         "pattern": "target/*.jar",
//         //                         "target": "spcjava-spc/"
//         //                     }
//         //                 ]
//         //             }'''
//         //         )

//         //         rtPublishBuildInfo(serverId: 'JFROG')
//         //     }
//         // }

//         stage('Spc java docker image build') {
//             steps {
//                sh "docker image build -t ${image_name}:${tag_name} ."
//             }
//         }
//         stage('trivy scan for image') {
//             steps {
//               sh "trivy image ${image_name}:${tag_name}"
//            }
//         }
//         stage('Image push to the ECR') {
//             steps {
//                 sh """aws ecr get-login-password --region us-west-2 | docker login --username AWS --password-stdin 741907363630.dkr.ecr.us-west-2.amazonaws.com && \
//                       docker tag ${image_name}:${tag_name} 741907363630.dkr.ecr.us-west-2.amazonaws.com/dev/spcjava:latest && \
//                       docker image ls && \
//                       docker push 741907363630.dkr.ecr.us-west-2.amazonaws.com/dev/spcjava:latest"""
//             }
//         }
//         stage('deploy to k8s for dev') {
//             steps {
//                 withCredentials([file(credentialsId: 'myeks', variable: 'KUBECONFIG')]) {
//                     sh 'kubectl apply -f deploy-k8s/.'
//                 }
//             }
//         }

//     }
// }




@Library ('my-repo-sharedLibrary')
pipeline {
    agent {
        label 'SPC'
    }
    stages {
        stage ('git checkout') {
            steps {
            git url: 'https://github.com/longflewtinku/spring-petclinic.git',
            branch: 'main'
            }   
        }
   
       stage('build') {
        steps {
            build()
        }
       }
    }
}