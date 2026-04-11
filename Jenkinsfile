pipeline {
    agent { label "docker-agent" }

    stages {
        stage("mr") {
            when {
                changeRequest()
            }
            stages {
                stage("checkstyle") {
                    steps { 
                        sh "mvn checkstyle:checkstyle"
                    }
                }
                stage("test") {
                    steps {
                        sh "mvn test"
                    }
                }
                stage("build") {
                    steps {
                        sh "mvn clean package -DskipTests"
                    }
                }
                stage("tag and push") {
                    steps {

                        sh "docker build -t spring-petclinic:${env.GIT_COMMIT.take(7)} ."
                        withCredentials([usernamePassword(
                            credentialsId: "nexus-creds",
                            usernameVariable: "USER",
                            passwordVariable: "PASS"
                        )]) {
                            sh "echo $PASS | docker login -u $USER --password-stdin host.docker.internal:5003"
                            sh "docker push host.docker.internal:5003/spring-petclinic:${env.GIT_COMMIT.take(7)}"
                        }
                    }
                }
            }
        }
        stage("main") {
            when {
                branch "main"
            }
            stages {
                stage("build") {
                    steps {
                        sh "mvn clean package -DskipTests" 
                    }
                }
                stage("tag and push") {
                    steps {
                        sh "docker build -t spring-petclinic:${env.GIT_COMMIT.take(7)} ."
                        withCredentials([usernamePassword(
                            credentialsId: "nexus-creds",
                            usernameVariable: "USER",
                            passwordVariable: "PASS"
                        )]) {
                            sh "echo $PASS | docker login -u $USER --password-stdin host.docker.internal:5002"
                            sh "docker push host.docker.internal:5002/spring-petclinic:${env.GIT_COMMIT.take(7)}"
                        }
                    }
                }
            }
        }
    }
}