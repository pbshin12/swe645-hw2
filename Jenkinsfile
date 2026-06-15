// Peter Shin (G01073633)
// Jenkins pipeline for building, pushing, and deploying the hw2 Docker image
pipeline {
    agent any
    parameters {
        booleanParam(name: 'DEPLOY', defaultValue: true, description: 'Deploy the image to Kubernetes')
    }
    environment {
        DOCKER_REPO = 'frozenmandu/swe645-hw2'
    }
    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/pbshin12/swe645-hw2.git'
            }
        }
        stage('Build') {
            steps {
                sh 'bash buildImage.sh -b -t ${BUILD_NUMBER}'
            }
        }
        stage('Push to Docker Hub') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'dockerhub-creds',
                    usernameVariable: 'DOCKER_USER',
                    passwordVariable: 'DOCKER_PASS'
                )]) {
                    sh 'bash buildImage.sh -b -t ${BUILD_NUMBER} -l -p'
                }
            }
        }
        stage('Deploy') {
            when {
                expression { params.DEPLOY }
            }
            steps {
                sh 'kubectl set image deployment/hw2-deployment hw2-container=${DOCKER_REPO}:${BUILD_NUMBER}'
            }
        }
    }
}
