pipeline {
    agent any

    stages {
        stage('Verify .github_token') {
            steps {
                script {
                    // Check if the .github_token exists
                    if (fileExists('.github_token')) {
                        echo '.github_token file exists'
                    } else {
                        error '.github_token file not found. Please ensure it is placed in the workspace root.'
                    }
                }
            }
        }

        stage('Clone Repository') {
            steps {
                script {
                    // Read the token from the file
                    def token = readFile('.github_token').trim()
                    if (token == null || token.isEmpty()) {
                        error 'GitHub token is empty. Please check the contents of .github_token.'
                    }
                    // Use the token in the Git URL
                    echo 'Cloning repository using GitHub token...'
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
            script {
                // Ensure the container is stopped and removed
                echo 'Stopping and removing Docker container...'
                bat '''
                docker stop flask-container || exit 0
                docker rm flask-container || exit 0
                '''
            }

            // Clean up the workspace to ensure a fresh environment for the next build
            cleanWs()
        }
    }
}
