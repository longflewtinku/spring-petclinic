pipeline {
  agent { label 'revestapp' }

  environment {
    IMAGE_NAME = "dev/revest"
    IMAGE_TAG = "latest"
    ECR_REPO = "888577027777.dkr.ecr.ap-south-1.amazonaws.com/dev/revest"
  }

  stages {
    stage('Checkout Code') {
      steps {
        git branch: 'main', url: 'https://github.com/longflewtinku/Revest-repo.git'
      }
    }
    stage('Build Docker Image') {
      steps {
        sh '''
          docker build -t ${IMAGE_NAME}:${IMAGE_TAG} .
        '''
      }
    }
    stage('Trivy Image Scan') {
      steps {
        sh '''
          trivy image ${IMAGE_NAME}:${IMAGE_TAG} || true
        '''
      }
    }
    stage('Tag & Push to ECR') {
      steps {
        sh '''
          docker tag ${IMAGE_NAME}:${IMAGE_TAG} ${ECR_REPO}:${IMAGE_TAG}
          docker push ${ECR_REPO}:${IMAGE_TAG}
        '''
      }
    }
    stage('Helm Deploy to Kubernetes') {
      steps {
        sh '''
          kubectl apply -f k8s/.
        '''
      }
    }
    stage('Verify Deployment') {
      steps {
        sh '''
          kubectl get all
        '''
      }
    }
  }

  // post {
  //   success {
  //     echo '✅ Build and deployment to ECR and Kubernetes completed successfully.'
  //   }
  //   failure {
  //     echo '❌ Pipeline failed. Please check the logs.'
  //   }
  // }
}
