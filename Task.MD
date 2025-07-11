# Steps

* Java-based Spring Petclinic application
* Create a multi-stage Dockerfile for the Spring Petclinic application on the `main`    branch
* Execute Dockerfile Using Command
```bash
# Create image command
docker image build -t spctimage:latest .
docker image build -t <your image:tag> (dockerfile name)
# Check if the image was created
docker image ls
# Check if your image is running in a container (for verification purposes)
docker container run -P -d --name mytest spctimage:latest
docker container run -P -d --name <container name> <your image:tag>
# Check if the container is running (to verify container status)
docker container ls
```
* Image Scanning with Trivy
* Now, to scan your image with Trivy, follow these steps:
* First, install Trivy on your jenkins instance.
```bash
sudo apt-get install wget apt-transport-https gnupg lsb-release
wget -qO - https://aquasecurity.github.io/trivy-repo/deb/public.key | gpg --dearmor | sudo tee /usr/share/keyrings/trivy.gpg > /dev/null
echo "deb [signed-by=/usr/share/keyrings/trivy.gpg] https://aquasecurity.github.io/trivy-repo/deb $(lsb_release -sc) main" | sudo tee -a /etc/apt/sources.list.d/trivy.list
sudo apt-get update
sudo apt-get install trivy -y
```
### After Trivy is installed, scan your image using the following command:
```bash
trivy image spcimage:latest
trivy image <image:tag>
```
#############################################################################################################################################################################
* Multiple developers have made changes, so we will scan the Docker image again.
* scan the Docker image with Trivy.
### After Trivy is installed, use the following command:
```bash
trivy image spcimage:1.0
trivy image <image:tag>
```
* The output will show vulnerabilities or reports.
* Pushing the Image to a Registry
* Once the image scan is completed, we can push the image to a registry such as Docker Hub, ECR
### To push to ECR, follow these steps:
```bash
docker login
docker image tag <docke image> <repousename>/<reponame>:<tag>
docker image tag revestimage:latest 888577027777.dkr.ecr.ap-south-1.amazonaws.com/dev/spc:latest
docker image push 888577027777.dkr.ecr.ap-south-1.amazonaws.com/dev/spc:latest
```
* Now pull the secret to the k8s 

```bash kubectl create secret docker-registry ecr-creds \
--docker-server=888577027777.dkr.ecr.ap-south-1.amazonaws.com \
--docker-username=AWS \
--docker-password="$(aws ecr get-login-password --region ap-south-1)"
```

#### Kubernetes Cluster Setup (CRI-Dockerd)
## Docker & CRI-Dockerd Setup (All Nodes)

```bash 
   curl -fsSL https://get.docker.com -o install-docker.sh 
   sh install-docker.sh
   sudo usermod -aG docker ubuntu
```
# Logout & Login again

``` bash
cd /tmp
wget https://github.com/Mirantis/cri-dockerd/releases/download/v0.3.16/cri-dockerd_0.3.16.3-0.ubuntu-jammy_amd64.deb
sudo dpkg -i cri-dockerd_0.3.16.3-0.ubuntu-jammy_amd64.deb
```

###  Install Kubernetes (All Nodes)
``` bash
sudo apt-get update
sudo apt-get install -y apt-transport-https ca-certificates curl gpg
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.32/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.32/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update
sudo apt-get install -y kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl
sudo systemctl enable --now kubelet
```
* now master means cluster login a root user after execute below the commands 
```bash
sudo -i
kubeadm init --cri-socket "unix:///var/run/cri-dockerd.sock"
```
* Now i want insall networking purpose Apply CNI Plugin (Weave)
```bash
kubectl apply -f https://github.com/weaveworks/weave/releases/download/v2.8.1/weave-daemonset-k8s.yaml
```
* Now im using join command on nodes Worker Node Join
```bash 
kubeadm join <master-ip>:6443 --token <token> \
  --discovery-token-ca-cert-hash sha256:<hash> \
  --cri-socket "unix:///var/run/cri-dockerd.sock"
 ```
 * Verify Cluster 
 ```bash
kubectl get nodes
kubectl get all
``` 
* Now Deploy Application Manifests
```bash
kubectl apply -f k8s/
kubectl get all
```
* Now I'll expose my application to customer traffic that's we need a nginx ingress controller so helm with install nginx controller
```bash
curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | bash
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update
helm install ingress-nginx ingress-nginx/ingress-nginx
```
## Domain Mapping
* my domain is being hosted from  cloudflare
```http://k8s4life.site```
## Prometheus & Grafana
* Now install prometheus and grafan with helm 
* Temporarily I'm using port-forwarding. we can use ingress manifest for static hosting.
```bash
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
helm install prometheus prometheus-community/kube-prometheus-stack
kubectl port-forward svc/prometheus-kube-prometheus-prometheus 9090:9090
kubectl port-forward svc/prometheus-grafana 3000:80
```
## Java & Jenkins Installation
* Above all should be done using CI/CD pipeline so i'm installing Jenkins 
```bash
sudo apt update 
sudo apt install openjdk-17-jdk -y

sudo wget -O /etc/apt/keyrings/jenkins-keyring.asc https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key
echo "deb [signed-by=/etc/apt/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/" | sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null
sudo apt update
sudo apt install jenkins -y
```
* Some follow the steps 
* Navigate to: http://<node-ip>:8080
* Configure credentials

* Install required plugins (Docker, Trivy, AWS CLI, GitHub) or already installed in master node or node
* Install AWS CLI and configure
```bash 
sudo apt install awscli -y
aws configure
```
Create a declarative pipeline for your CI/CD project that:
* Builds Docker image
* Scans with Trivy
* Pushes to ECR
* Deploys to Kubernetes using kubectl 


* And one more thing i will check my application manully ( not inclded in pipeline) 
