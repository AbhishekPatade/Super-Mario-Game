pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "yourdockerhubusername/super-mario:latest"
        AWS_REGION = "ap-south-1"
        EKS_CLUSTER = "eks-oncdecb31"
    }

    stages {

        stage('Clean Workspace') {
            steps {
                cleanWs()
            }
        }

        stage('Checkout Source') {
            steps {
                git branch: 'main',
                url: 'https://github.com/YourUsername/Super-Mario-Game.git'
            }
        }

        stage('Configure kubectl') {
            steps {
                sh '''
                aws eks update-kubeconfig \
                --region $AWS_REGION \
                --name $EKS_CLUSTER

                kubectl get nodes
                '''
            }
        }

        stage('Pull Docker Image') {
            steps {
                sh '''
                docker pull $DOCKER_IMAGE
                '''
            }
        }

        stage('Trivy Image Scan') {
            steps {
                sh '''
                trivy image --severity HIGH,CRITICAL $DOCKER_IMAGE
                '''
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                sh '''
                kubectl apply -f k8s/namespace.yaml
                kubectl apply -f k8s/deployment.yaml
                kubectl apply -f k8s/service.yaml
                '''
            }
        }

        stage('Verify Deployment') {
            steps {
                sh '''
                kubectl get pods -n mario
                kubectl get svc -n mario
                kubectl rollout status deployment/mario -n mario
                '''
            }
        }

    }

    post {

        success {
            echo 'Deployment Successful!'
        }

        failure {
            echo 'Deployment Failed!'
        }

    }
}   