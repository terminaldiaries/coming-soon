// Declarative Pipeline syntax
pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "bbamba/coming-soon"
        DOCKER_TAG = "1.0.0"
        REGISTRY_CREDENTIALS = "dockerhub-credentials"
        KUBE_CONFIG = "$HOME/.kube/config"
    }

    stages {
        stage('Checkout Code') {
            steps {
                checkout scm
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    sh "docker build -t ${DOCKER_IMAGE}:${DOCKER_TAG} ."
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                withCredentials([usernamePassword(credentialsId: "${REGISTRY_CREDENTIALS}",usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    script {
                        sh """
                            echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin
                            docker push ${DOCKER_IMAGE}:${DOCKER_TAG}
                            docker logout
                           """
                    }
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                script {
                    // apply manifest deployment
                    sh "kubectl apply -f k8s/deployment.yml"
                    sh "kubectl apply -f k8s/service.yml"
                }
            }
        }
    }
    post {
        success {
            echo "🚀 Website deployed successfully on Kubernetes!"
        }
        failure {
            echo "❌ Deployment failed!"
        }
    }
}