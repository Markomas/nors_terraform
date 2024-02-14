pipeline {
    agent any

    stages {
        stage('Terraform init') {
            steps {
                sh 'terraform init'
            }
        }

        stage('Terraform Plan') {
            steps {
                script {
                    sh 'terraform plan -out=tfplan'
                }
            }
        }
//         stage('Terraform apply') {
//             steps {
//                 sh 'terraform apply --auto-approve tfplan'
//             }
//         }
        stage('Upload State to backup') {
            steps {
                sshPublisher(
                  continueOnError: false,
                  failOnError: true,
                  publishers: [
                    sshPublisherDesc(
                      configName: "baublas",
                      transfers: [
                        sshTransfer(sourceFiles: 'terraform.tfstate'),
                        sshTransfer(sourceFiles: 'terraform.tfstate.backup')
                      ],
                      verbose: true
                    )
                  ]
                )
            }
        }
    }
}