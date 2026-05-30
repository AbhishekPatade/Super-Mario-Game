# 🚀 Super Mario on AWS EKS using Terraform

This project demonstrates how to deploy the **Super Mario application** on **Amazon EKS (Elastic Kubernetes Service)** using **Terraform**, **Docker**, **AWS CLI**, and **Kubectl**.

## 📌 Prerequisites

* AWS Account
* EC2 Instance (Ubuntu or Amazon Linux)
* IAM Role with Administrator Access
* Docker
* Terraform
* AWS CLI
* Kubectl
* Git

---

# 🏗️ Project Workflow

### Step 1: Launch EC2 Instance

1. Login to AWS Console.
2. Navigate to **EC2 Dashboard**.
3. Click **Launch Instance**.
4. Connect to the instance using **EC2 Instance Connect**.
5. Attach an IAM Role to the EC2 instance.

---

## Step 2: Install Required Tools

### Update System

```bash
sudo apt update -y
```

---

## Install Docker

### Ubuntu

```bash
sudo apt install docker.io -y
sudo systemctl start docker
sudo usermod -aG docker ubuntu
newgrp docker
docker --version
```

### Amazon Linux

```bash
sudo yum install docker -y
sudo systemctl start docker
sudo usermod -aG docker ec2-user
newgrp docker
docker --version
```

---

## Install Terraform

### Ubuntu

```bash
wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg

echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list

sudo apt update
sudo apt install terraform -y

terraform version
```

### Amazon Linux

```bash
sudo yum install -y yum-utils shadow-utils

sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo

sudo yum install terraform -y

terraform version
```

---

## Install AWS CLI

```bash
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"

sudo apt install unzip -y

unzip awscliv2.zip

sudo ./aws/install

aws --version
```

---

## Install Kubectl

### Download Kubectl

```bash
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
```

### Install Kubectl

```bash
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
```

### Verify Installation

```bash
kubectl version --client
```

---

# 🔐 Step 3: Create IAM Role

Create a new IAM Role with the following permissions:

* AdministratorAccess

Role Name:

```text
role-ec2
```

---

# 🔗 Step 4: Attach IAM Role to EC2

1. Open EC2 Dashboard.
2. Select your EC2 Instance.
3. Click:

```text
Actions → Security → Modify IAM Role
```

4. Select:

```text
role-ec2
```

5. Click **Update IAM Role**.

---

# ☁️ Step 5: Build AWS EKS Infrastructure Using Terraform

## Install Git

```bash
sudo apt install git -y
```

## Clone Repository

```bash
git clone https://github.com/Alpesh-Rajendra/Project-Super-Mario.git

cd Project-Super-Mario/EKS-TF
```

---

## Initialize Terraform

```bash
terraform init
```

## Validate Terraform Code

```bash
terraform plan
```

## Create Infrastructure

```bash
terraform apply --auto-approve
```

---

## Configure EKS Cluster Access

```bash
aws eks update-kubeconfig \
--name EKS_CLOUD \
--region ap-southeast-1
```

Verify Cluster:

```bash
kubectl get nodes
```

---

# 🚀 Step 6: Deploy Application on EKS

Move to Kubernetes Manifest Directory:

```bash
cd ..
```

## Create Deployment

```bash
kubectl apply -f deployment.yaml
```

## Create Service

```bash
kubectl apply -f service.yaml
```

---

## Verify Resources

```bash
kubectl get all

kubectl get svc mario-service
```

Example Output:

```bash
NAME            TYPE           EXTERNAL-IP
mario-service   LoadBalancer   a1b2c3d4.amazonaws.com
```

---

## Access Application

1. Copy the Load Balancer DNS Name from:

```bash
kubectl get svc mario-service
```

2. Paste it into your browser.

🎮 Super Mario Game will be available.

---

# 📊 Architecture

```text
Developer
    │
    ▼
EC2 Instance
    │
    ├── Terraform
    ├── AWS CLI
    └── Kubectl
    │
    ▼
Amazon EKS Cluster
    │
    ▼
Deployment
    │
    ▼
Service (LoadBalancer)
    │
    ▼
Super Mario Application
```

---

# 🧹 Destroy Infrastructure

To avoid AWS charges, destroy all resources after testing:

```bash
terraform destroy --auto-approve
```

---

# 📸 Final Output

✅ EKS Cluster Created

✅ Kubernetes Deployment Created

✅ LoadBalancer Service Created

✅ Super Mario Application Running

---

## 🛠️ Tech Stack

* AWS EC2
* Amazon EKS
* Terraform
* Docker
* Kubernetes
* AWS CLI
* Kubectl
* Git

---

## ⭐ Author

Abhishek Santosh Patade

If you found this project useful, give it a ⭐ on GitHub.

