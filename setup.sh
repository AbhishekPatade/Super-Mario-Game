#!/bin/bash

set -e

echo "======================================"
echo "Updating System..."
echo "======================================"

sudo apt update -y
sudo apt upgrade -y

#########################################################
# Install Git
#########################################################

echo "Installing Git..."

sudo apt install git -y

#########################################################
# Install Java 17
#########################################################

echo "Installing Java 17..."

sudo mkdir -p /etc/apt/keyrings

wget -qO - https://packages.adoptium.net/artifactory/api/gpg/key/public \
| sudo tee /etc/apt/keyrings/adoptium.asc >/dev/null

echo "deb [signed-by=/etc/apt/keyrings/adoptium.asc] https://packages.adoptium.net/artifactory/deb \
$(. /etc/os-release && echo $VERSION_CODENAME) main" \
| sudo tee /etc/apt/sources.list.d/adoptium.list

sudo apt update -y
sudo apt install temurin-17-jdk -y

java -version

#########################################################
# Install Jenkins
#########################################################

echo "Installing Jenkins..."

curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key \
| sudo tee /usr/share/keyrings/jenkins-keyring.asc >/dev/null

echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
https://pkg.jenkins.io/debian-stable binary/" \
| sudo tee /etc/apt/sources.list.d/jenkins.list >/dev/null

sudo apt update -y

sudo apt install jenkins -y

sudo systemctl enable jenkins
sudo systemctl start jenkins

#########################################################
# Install Docker
#########################################################

echo "Installing Docker..."

sudo apt install docker.io -y

sudo systemctl enable docker
sudo systemctl start docker

sudo usermod -aG docker ubuntu

sudo chmod 666 /var/run/docker.sock

docker --version

#########################################################
# Install AWS CLI v2
#########################################################

echo "Installing AWS CLI..."

curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" \
-o "awscliv2.zip"

sudo apt install unzip -y

unzip -o awscliv2.zip

sudo ./aws/install

aws --version

#########################################################
# Install kubectl
#########################################################

echo "Installing kubectl..."

curl -LO "https://dl.k8s.io/release/$(curl -L -s \
https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"

chmod +x kubectl

sudo mv kubectl /usr/local/bin/

kubectl version --client

#########################################################
# Install eksctl
#########################################################

echo "Installing eksctl..."

curl --silent --location \
"https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" \
| tar xz -C /tmp

sudo mv /tmp/eksctl /usr/local/bin

eksctl version

#########################################################
# Install Trivy
#########################################################

echo "Installing Trivy..."

sudo apt install wget gnupg lsb-release -y

wget -qO - https://aquasecurity.github.io/trivy-repo/deb/public.key \
| gpg --dearmor \
| sudo tee /usr/share/keyrings/trivy.gpg >/dev/null

echo "deb [signed-by=/usr/share/keyrings/trivy.gpg] \
https://aquasecurity.github.io/trivy-repo/deb \
$(lsb_release -cs) main" \
| sudo tee /etc/apt/sources.list.d/trivy.list

sudo apt update -y

sudo apt install trivy -y

trivy --version

#########################################################
# Install Sonar Scanner (Optional)
#########################################################

echo "Installing Sonar Scanner..."

wget https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-7.1.0.4889-linux-x64.zip

unzip -o sonar-scanner-cli-7.1.0.4889-linux-x64.zip

sudo mv sonar-scanner-7.1.0.4889-linux-x64 /opt/sonar-scanner

echo 'export PATH=$PATH:/opt/sonar-scanner/bin' >> ~/.bashrc

export PATH=$PATH:/opt/sonar-scanner/bin

sonar-scanner --version || true

#########################################################
# Final Versions
#########################################################

echo ""
echo "======================================"
echo "Installed Versions"
echo "======================================"

git --version
java -version
docker --version
jenkins --version || true
aws --version
kubectl version --client
eksctl version
trivy --version

echo ""
echo "======================================"
echo "Setup Completed Successfully!"
echo "======================================"

echo ""
echo "Next Steps:"
echo "1. Create your EKS Cluster"
echo "2. Run aws configure"
echo "3. aws eks update-kubeconfig --name <cluster-name> --region <region>"
echo "4. Open Jenkins on http://<EC2-Public-IP>:8080"