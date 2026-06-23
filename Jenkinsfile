pipeline {
    agent any // Tells Jenkins to run this pipeline on any available executor

    environment {
        // Define environment variables here if needed
        DOCKERHUB_USERNAME = 'eth420kplus'
        IMAGE_NAME = 'static-form'
        IMAGE_TAG = 'latest'
    }

    stages {
        stage('Checkout Code') {
            steps {
                // Pull code from GitHub repository
                echo 'Pulling code from GitHub...'
                git branch: 'main', url: 'https://github.com/BrihaspatiThapa/SWE645_HW2.git'
            }
        }
        stage('Build Docker Image') {
            steps {
                script {
                    // Build Docker image using the Dockerfile in the repository
                    // Store the built image in a variable for later use
                    echo 'Building Docker image...'
                    dockerImage = docker.build("${DOCKERHUB_USERNAME}/${IMAGE_NAME}:${IMAGE_TAG}")
                }
            }
        }
        stage('Push Docker Image to Docker Hub') {
            steps {
                script {
                     // Push the built Docker image to Docker Hub
                    echo 'Pushing Docker image to Docker Hub...'
                    docker.withRegistry('https://index.docker.io/v1/', 'docker') {
                        dockerImage.push()
                    }
                }
            }
        }
        stage('Update Kubernetes Deployment') {
            steps {
                script {
                    echo 'Updating Kubernetes deployment...'
                    //Run the replacement command to update the image in the deployment.yaml file
                    sh "sed -i 's|image: .*|image: ${DOCKERHUB_USERNAME}/${IMAGE_NAME}:${IMAGE_TAG}|' deployment.yaml"
                    echo 'Verifying the updated deployment.yaml file...'
                    sh "cat deployment.yaml"
                    echo '----------------------------------------------------'
                    sh """
                    kubectl apply -f deployment.yaml
                    kubectl apply -f service.yaml
                    """
                }
            }
        }
    }
    
    post {
        always {
            echo 'Pipeline has finished execution.'
        }
        success {
            echo 'Build completed successfully!'
        }
        failure {
            echo 'Build failed. Please check the logs.'
        }
    }
}
