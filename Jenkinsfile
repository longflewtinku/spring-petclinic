pipeline {
    agent {
        label 'JDKJAVASPC'  // Ensure this label corresponds to your Jenkins node
    }
    triggers {
        pollSCM('* * * * *')
    }
    stages {
        stage('GIT CHECKOUT') {
            steps {
                git url: 'https://github.com/longflewtinku/spring-petclinic.git', branch: 'main'
            }
        }

        stage('Build and SonarQube Scan') {
            steps {
                withCredentials([string(credentialsId: 'sonar_id', variable: 'SONAR_TOKEN')]) {
                    withSonarQubeEnv('SONARQUBE') {  // Ensure 'SONARQUBE' is configured in Jenkins
                        sh '''
                            mvn clean package sonar:sonar \
                            -Dsonar.projectKey=longflewtinku_spring-petclinic \
                            -Dsonar.organization=jenkinsjava \
                            -Dsonar.host.url=https://sonarcloud.io \
                            -Dsonar.login=$SONAR_TOKEN
                        '''
                    }
                }
            }
        }

        stage('Upload to JFrog Artifactory') {
            steps {
                rtupload(
                    serverId: 'JFROG_SPC_JAVA',  // Ensure the JFrog credentials are correct
                    spec: ''' 
                    {
                        "files": [
                            {
                                "pattern": "target/*.jar",
                                "target": "jfrogjavaspc-libs-release-local/"
                            }
                        ]
                    }
                    '''
                )
                rtPublishBuildInfo(serverId: 'JFROG_SPC_JAVA')  // Publish build info to JFrog Artifactory
            }
        }
        stage('Docker image build') {
            steps {
                sh 'docker image build -t java:1.0 .'
                sh ' docker image ls'
            }
        }
    }

    post {
        always {
            // Archive the JAR files and test reports regardless of the pipeline result
            archiveArtifacts artifacts: '**/target/*.jar'
            junit '**/target/surefire-reports/*.xml'
        }

        success {
            echo 'Pipeline executed successfully.'
        }

        failure {
            echo 'Pipeline failed. Please check the logs for errors.'
        }
    }
}
