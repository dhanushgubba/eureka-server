pipeline {
    agent any

    environment {
        // Define your desired repository name in the DOCKER_REPO variable
        DOCKER_REPO = 'dhanushgubba' 
        DOCKER_IMAGE = 'eureka-server'
        DOCKER_TAG = 'latest'
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/dhanushgubba/eureka-server.git'
            }
        }

        stage('Build Maven') {
            steps {
                // Ensure the build tool is available on the agent
                sh 'mvn clean package -DskipTests'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    // Use the defined environment variables to tag the image
                    sh "docker build -t ${DOCKER_IMAGE}:${DOCKER_TAG} ."
                }
            }
        }

        stage('Push to DockerHub') {
            steps {
                // This block securely uses credentials stored in Jenkins
                withCredentials([usernamePassword(
                    credentialsId: 'dockerhub',
                    usernameVariable: 'DOCKER_USERNAME',
                    passwordVariable: 'DOCKER_PASSWORD'
                )]) {
                    script {
                        // The repository name must be the DockerHub username for the push to work
                        def FULL_IMAGE_NAME = "${DOCKER_USERNAME}/${DOCKER_IMAGE}:${DOCKER_TAG}"

                        sh """
                            echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USERNAME" --password-stdin
                            docker tag ${DOCKER_IMAGE}:${DOCKER_TAG} ${FULL_IMAGE_NAME}
                            docker push ${FULL_IMAGE_NAME}
                        """
                    }
                }
            }
        }
    }
    
    // =========================================================================
    // POST-BUILD ACTIONS: CRITICAL for preventing disk space issues (like the one you hit)
    // =========================================================================
    post {
        // Runs regardless of the stage result (success or failure)
        always {
            echo 'Cleaning up the workspace to free up disk space...'
            // Deletes the files in the workspace (source code, target folders, etc.)
            deleteDir() 
        }
        // You might also want to clean up the local Docker images after a successful push
        success {
            echo 'Cleaning up local Docker image...'
            withCredentials([usernamePassword(
                credentialsId: 'dockerhub',
                usernameVariable: 'DOCKER_USERNAME',
                passwordVariable: 'DOCKER_PASSWORD'
            )]) {
                // Remove the local tag, allowing Docker to reclaim space if the image is no longer in use
                sh "docker rmi -f ${DOCKER_USERNAME}/${DOCKER_IMAGE}:${DOCKER_TAG}"
            }
        }
    }
}