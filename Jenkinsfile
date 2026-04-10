pipeline {
    agent {
        label "docker-agent"
    }

    stages {
        stage('Checkstyle') {
            steps {
                sh "mvn checkstyle:checkstyle"
            }
        }

        stage('Test') {
            steps {
               sh "mvn test"
            }
        }

        stage('Build') {
            steps {
               sh "mvn clean package -DskipTests"
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
                    sh "docker build -t ${imageName} ."

                    // Login & push
                    withCredentials([usernamePassword(credentialsId: 'nexus-creds', usernameVariable: 'USER', passwordVariable: 'PASS')]) {
                        sh "echo $PASS | docker login ${nexusURL} -u $USER --password-stdin"
                        sh "docker push ${imageName}"
                    }
                }
            }
        }
    }
}