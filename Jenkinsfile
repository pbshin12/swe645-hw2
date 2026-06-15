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
                script {
                    dockerImage = docker.build("${DOCKER_REPO}:${BUILD_NUMBER}")
                }
            }
        }
        stage('Push to Docker Hub') {
            steps {
                script {
                    docker.withRegistry('https://index.docker.io/v1/', 'dockerhub-creds') {
                        dockerImage.push()
                    }
                }
            }
        }
        stage('Deploy') {
            when {
                expression { params.DEPLOY }
            }
            steps {
                sh 'kubectl set image deployment/hw2-deployment hw2-container=${DOCKER_REPO}:${BUILD_NUMBER} -n default'
            }
        }
    }
    post {
        success {
            echo 'Deployment successful'
        }
        failure {
            echo 'Deployment failed'
        }
    }
}
