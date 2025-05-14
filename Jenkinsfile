pipeline {
  agent { label 'revestapp' }

  environment {
    IMAGE_NAME = "dev/revest"
    IMAGE_TAG = "latest"
    ECR_REGISTRY = "888577027777.dkr.ecr.ap-south-1.amazonaws.com"
    ECR_REPO = "${ECR_REGISTRY}/${IMAGE_NAME}"
    AWS_REGION = "ap-south-1"
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
          trivy image ${IMAGE_NAME}:${IMAGE_TAG}
        '''
      }
    }

    stage('Login to ECR') {
      steps {
        sh '''
          aws ecr get-login-password --region ${AWS_REGION} | docker login --username AWS --password-stdin ${ECR_REGISTRY}
          kubectl create secret docker-registry ecr-creds \
            --docker-server=${ECR_REGISTRY} \
            --docker-username=AWS \
            --docker-password="$(aws ecr get-login-password --region ${AWS_REGION})" \
            --dry-run=client -o yaml | kubectl apply -f -
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

    stage('Install Helm and Repos') {
      steps {
        sh '''
          curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

          helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
          helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
          helm repo add grafana https://grafana.github.io/helm-charts
          helm repo update
        '''
      }
    }

    stage('Install NGINX Ingress Controller') {
      steps {
        sh '''
          helm upgrade --install ingress-nginx ingress-nginx/ingress-nginx \
            --namespace ingress-nginx --create-namespace
        '''
      }
    }

    stage('Install Prometheus and Grafana') {
      steps {
        sh '''
          helm upgrade --install prometheus prometheus-community/prometheus \
            --namespace monitoring --create-namespace

          helm upgrade --install grafana grafana/grafana \
            --namespace monitoring --create-namespace \
            --set adminPassword=admin \
            --set service.type=NodePort
        '''
      }
    }

    stage('Deploy Spring App to Kubernetes') {
      steps {
        sh '''
          kubectl apply -f k8s/.
        '''
      }
    }

    stage('Check All Resources') {
      steps {
        sh '''
          kubectl get all --all-namespaces
        '''
      }
    }
  }
}
