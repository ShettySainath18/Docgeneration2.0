pipeline {
    agent any

    stages {
        stage('Clone Repository') {
            steps {
                script {
                    // Read the token from the file
                    def token = readFile('.github_token').trim()
                    // Use the token in the Git URL
                    git url: "https://${token}@github.com/ShettySainath18/automated_Documentation.git"
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                bat '''
                REM Build the Docker image
                docker build -t flask-hello-world .
                '''
            }
        }

        stage('Run Dockerized Application') {
            steps {
                bat '''
                REM Run the Docker container
                docker run -d --name flask-container -p 5000:5000 flask-hello-world
                '''
            }
        }

        stage('Extract and Publish Documentation') {
            steps {
                bat '''
                REM Copy the generated documentation from the container to Jenkins workspace
                docker cp flask-container:/app/docs/_build/html ./generated-docs
                '''

                // Archive the built HTML documentation as artifacts
                archiveArtifacts artifacts: 'generated-docs/**', fingerprint: true

                // Publish the documentation as an HTML report
                publishHTML(target: [
                    allowMissing: false,
                    alwaysLinkToLastBuild: true,
                    keepAll: true,
                    reportDir: 'generated-docs',
                    reportFiles: 'index.html',
                    reportName: 'Flask Project Documentation'
                ])
            }
        }
    }

    post {
        always {
            bat '''
            REM Stop and remove the Docker container
            docker stop flask-container || exit 0
            docker rm flask-container || exit 0
            '''

            // Clean up the workspace
            cleanWs()
        }
    }
}