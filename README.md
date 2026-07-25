# Super Mario Application Deployment on AWS EKS using Jenkins

This project demonstrates a complete CI/CD pipeline for deploying the Super Mario application on Amazon Elastic Kubernetes Service (EKS) using Jenkins.

The infrastructure (EC2 and EKS cluster) is created manually. Once the environment is ready, Jenkins automates the complete deployment process, including pulling the Docker image, scanning it with Trivy, and deploying the application to Kubernetes.

---

# Prerequisites

- AWS Account
- GitHub Account
- Docker Hub Account
- IAM User with AdministratorAccess
- Ubuntu 22.04 EC2 Instance
- SSH Key Pair

---

# Tools Required

- Java 17
- Git
- Jenkins
- Docker
- AWS CLI
- kubectl
- eksctl
- Trivy

---

# Project Structure

```
Super-Mario-Game
│
├── Jenkinsfile
├── setup.sh
├── README.md
│
└── k8s
    ├── namespace.yaml
    ├── deployment.yaml
    └── service.yaml
```

---

# Launch EC2 (Ubuntu 22.04)

Create an Ubuntu 22.04 EC2 instance.

Recommended Configuration

- AMI : Ubuntu Server 22.04 LTS
- Instance Type : t2.large
- Storage : 30 GB

Configure the Security Group.

| Port | Purpose |
|------|----------|
| 22 | SSH |
| 80 | Application |
| 8080 | Jenkins |

Connect to the instance.

```bash
ssh -i <your-key.pem> ubuntu@<Public-IP>
```

---

# Clone Repository

Clone the project repository.

```bash
git clone https://github.com/<your-username>/Super-Mario-Game.git
```

Move inside the project.

```bash
cd Super-Mario-Game
```

---

# Install Required Tools

Run the setup script.

```bash
chmod +x setup.sh
```

```bash
./setup.sh
```

The script installs

- Java
- Jenkins
- Docker
- Git
- AWS CLI
- kubectl
- eksctl
- Trivy

Verify the installation.

```bash
java -version
docker --version
aws --version
kubectl version --client
eksctl version
trivy --version
```

---

# Configure AWS CLI

Configure your AWS credentials.

```bash
aws configure
```

Verify.

```bash
aws sts get-caller-identity
```

---

# Create Amazon EKS Cluster

Create the EKS cluster.

```bash
eksctl create cluster \
--name mario-cluster \
--region ap-south-1 \
--nodegroup-name worker-nodes \
--node-type t3.medium \
--nodes 2 \
--managed
```

Cluster creation takes approximately **15–20 minutes**.

---

# Verify EKS Cluster

Verify the cluster.

```bash
eksctl get cluster
```

Verify worker nodes.

```bash
kubectl get nodes
```

Verify Kubernetes.

```bash
kubectl cluster-info
```

At this point, the infrastructure setup is complete.

The remaining deployment process is handled automatically by the Jenkins CI/CD pipeline.


# Configure Jenkins

Open Jenkins in your browser.

```
http://<EC2-Public-IP>:8080
```

Unlock Jenkins.

```bash
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
```

Copy the password and paste it into the Jenkins setup page.

Click **Install Suggested Plugins**.

Create an Administrator account.

Jenkins is now ready to use.

---

# Install Required Jenkins Plugins

Go to

```
Manage Jenkins

↓

Plugins

↓

Available Plugins
```

Install the following plugins.

- Docker
- Docker Pipeline
- Pipeline
- Git
- GitHub
- Credentials Binding
- Pipeline Stage View
- Workspace Cleanup
- SSH Agent

Restart Jenkins after installing the plugins.

```
http://<EC2-Public-IP>:8080/restart
```

---

# Configure Docker for Jenkins

Allow Jenkins to access Docker.

```bash
sudo usermod -aG docker jenkins
```

```bash
sudo usermod -aG docker ubuntu
```

```bash
sudo chmod 777 /var/run/docker.sock
```

Restart Jenkins.

```bash
sudo systemctl restart jenkins
```

Verify Docker access.

```bash
docker ps
```

---

# Configure Jenkins Credentials

Go to

```
Manage Jenkins

↓

Credentials

↓

System

↓

Global Credentials

↓

Add Credentials
```

### Docker Hub Credentials

Select

```
Kind : Username with Password
```

Fill the details.

```
Username : <DockerHub Username>

Password : <DockerHub Password>

ID : docker-cred
```

Click **Create**.

---

### AWS Credentials (Optional)

If your EC2 instance is **not attached to an IAM Role**, add AWS credentials.

```
Kind : AWS Credentials
```

Provide

- Access Key
- Secret Key

Credential ID

```
aws-cred
```

> **Note:** If the EC2 instance already has an IAM Role with the required permissions, this step can be skipped.

---

# Create Jenkins Pipeline Job

From the Jenkins Dashboard,

```
New Item

↓

Enter Item Name

↓

Super-Mario-CICD

↓

Pipeline

↓

OK
```

Under **Pipeline**

```
Definition

↓

Pipeline script from SCM
```

SCM

```
Git
```

Repository URL

```
https://github.com/<your-github-username>/Super-Mario-Game.git
```

Branch

```
*/main
```

Script Path

```
Jenkinsfile
```

Click **Save**.


# Configure GitHub Webhook

Open your GitHub repository.

```
Repository

↓

Settings

↓

Webhooks

↓

Add Webhook
```

Configure the webhook.

**Payload URL**

```
http://<EC2-Public-IP>:8080/github-webhook/
```

**Content Type**

```
application/json
```

**Which events would you like to trigger this webhook?**

```
Just the push event
```

Click **Add Webhook**.

---

# Build the Pipeline

Go to the Jenkins Dashboard.

```
Super-Mario-CICD

↓

Build Now
```

Click on the build number.

```
#1

↓

Console Output
```

You should see the pipeline executing successfully.

---

# Jenkins Pipeline Workflow

The pipeline performs the following tasks automatically.

```
Clean Workspace

↓

Clone GitHub Repository

↓

Pull Docker Image

↓

Scan Docker Image using Trivy

↓

Configure kubectl

↓

Create Kubernetes Namespace

↓

Deploy Application

↓

Create LoadBalancer Service

↓

Verify Deployment
```

No manual Kubernetes deployment is required.

---

# Verify Deployment

Check the running Pods.

```bash
kubectl get pods -n mario
```

Check the Deployment.

```bash
kubectl get deployment -n mario
```

Check the Service.

```bash
kubectl get svc -n mario
```

Example Output

```text
NAME            TYPE           EXTERNAL-IP
mario-service   LoadBalancer   a1b2c3d4.ap-south-1.elb.amazonaws.com
```

---

# Access the Application

Copy the **EXTERNAL-IP** of the LoadBalancer.

Open your browser.

```
http://<EXTERNAL-IP>
```

The Super Mario application should now be accessible.

---

# Project Workflow

```
Developer

↓

Push Code to GitHub

↓

GitHub Webhook

↓

Jenkins Pipeline Triggered

↓

Checkout Repository

↓

Pull Docker Image

↓

Trivy Security Scan

↓

Configure kubectl

↓

Deploy to Amazon EKS

↓

Application Running on Kubernetes
```

---

# Cleanup

Delete the EKS Cluster.

```bash
eksctl delete cluster --name mario-cluster --region ap-south-1
```

Terminate the EC2 instance from the AWS Console to avoid unnecessary charges.


