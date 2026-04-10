pipeline {
    agent {
        label "docker-agent"
    }

    stages {
        stage('Checkstyle') {
            steps {
                mvn Checkstyle:Checkstyle
            }
        }

        stage('Test') {
            steps {
                mvn test
            }
        }

        stage('Build') {
            steps {
                mvn clean package -DskipTests
            }
        }

        stage('Docker Build & Push') {
            steps {
                script {
                    def shortCommit = env.GIT_COMMIT.take(7)

                    def nexusURL = "localhost:5003"
                    def repo = "mr"
                    def imageName = "${nexusURL}/${repo}/spring-petclinic:${shortCommit}"

                    //build image
                    sh "Docker build -t ${imageName} ."

                    // Login & push
                    withCredentials([usernamePassword(credentialsId: 'nexus-creds', usernameVariable: 'USER', passwordVariable: 'PASS')]) {
                        sh "echo $PASS | docker login ${nexusUrl} -u $USER --password-stdin"
                        sh "docker push ${imageName}"
                    }
                }
            }
        }
    }
}