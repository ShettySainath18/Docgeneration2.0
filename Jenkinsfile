pipeline {
    agent any

    stages {
        stage('Clone Repository') {
            steps {
                // Use the credentialsId to securely provide the GitHub PAT
                git branch:'main', credentialsId: 'github-pat', url: 'https://github.com/ShettySainath18/Docgeneration2.0.git'
            }
        }

        stage('SonarQube Analysis') {
            steps {
                script {
                    // Use the token securely
                    withCredentials([string(credentialsId: 'sonarqube', variable: 'SONAR_TOKEN')]) {
                        // Replace 'SonarQubeScanner' with the actual tool name if different
                        def scannerHome = tool 'SonarQube'
                        bat """
                            ${scannerHome}\\bin\\sonar-scanner ^
                                -Dsonar.projectKey=automated_doc_generator ^
                                -Dsonar.sources=. ^
                                -Dsonar.host.url=http://10.219.36.129:9000 ^
                                -Dsonar.login=$SONAR_TOKEN
                        """
                    }
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
                docker cp flask-container:/app/docs/ ./generated-docs
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
                echo 'Stopping and removing Docker container...'
                bat '''
                docker ps -a --filter "name=flask-container" --format "{{.Names}}" | find "flask-container" >nul
                if %ERRORLEVEL% EQU 0 (
                    docker stop flask-container
                    docker rm flask-container
                ) else (
                    echo "Container flask-container does not exist. Skipping stop and remove."
                )
                '''
            }

            // Clean up the workspace
            cleanWs()
        }
    }
}
