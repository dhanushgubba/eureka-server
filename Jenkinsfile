pipeline {
    agent any

    environment {
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
                bat 'mvn clean package -DskipTests'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    bat "docker build -t ${DOCKER_IMAGE}:${DOCKER_TAG} ."
                }
            }
        }

        stage('Push to DockerHub') {
            steps {
                withCredentials([
                    usernamePassword(
                        credentialsId: 'dockerhub',
                        usernameVariable: 'DOCKER_USERNAME',
                        passwordVariable: 'DOCKER_PASSWORD'
                    )
                ]) {
                    script {
                        bat """
                            docker login -u %DOCKER_USERNAME% -p %DOCKER_PASSWORD%
                            docker tag ${DOCKER_IMAGE}:${DOCKER_TAG} %DOCKER_USERNAME%/${DOCKER_IMAGE}:${DOCKER_TAG}
                            docker push %DOCKER_USERNAME%/${DOCKER_IMAGE}:${DOCKER_TAG}
                        """
                    }
                }
            }
        }
    }
}
