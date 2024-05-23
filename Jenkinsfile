pipeline {
    agent any
    environment {
                PROJECT_ID = "marketplacedev-416018"
                TF_STATE_BUCKET_NAME = "marketplacedev-bucket"
    }
    stages {
        stage('terraform init and apply') {
            steps {
                script {
                    withCredentials([file(credentialsId: 'GOOGLE_AUTH', variable: 'GOOGLE_APPLICATION_CREDENTIALS')]) {
                        sh """
                        export GOOGLE_APPLICATION_CREDENTIALS=${GOOGLE_APPLICATION_CREDENTIALS}
                        terraform init -backend-config="bucket=${TF_STATE_BUCKET_NAME}" -backend-config="prefix=terraform/state"
                        terraform apply --auto-approve -var="project-id=${PROJECT_ID}"
                        """
                    }
                }
            }
        }
        stage('terraform action') {
            steps {
                script {
                    echo "Terraform action is -> ${action}"
                    sh "terraform ${action} --auto-approve"
                }
            }
        }
    }
}
