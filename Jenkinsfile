pipeline {
    agent {
        label "docker-agent"
    }

    stages {
        stage("mr pipeline") {
                when {
                    branch "mr"
                }
                steps {
                    sh "mvn checkstyle:checkstyle"
                    sh "mvn test"
                    sh "mvn clean package -DskipTests"
                    script {
                        def shortCommit = env.GIT_COMMIT.take(7)

                        def nexusURL = "host.docker.internal:5003"
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
        stage("main pipeline") {
            when {
                branch "main"
            }
            steps {
                script {
                     def shortCommit = env.GIT_COMMIT.take(7)

                        def nexusURL = "host.docker.internal:5003"
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