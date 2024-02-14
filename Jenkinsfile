pipeline {
    agent any

    stages {
        stage('Terraform init') {
            steps {
            sshagent(['jenkins_agent']) {
                    sh 'terraform init'
                }
            }
        }

        stage('Terraform Plan') {
            steps {
            sshagent(['jenkins_agent']) {
                    script {
                        sh 'terraform plan -out=tfplan'
                    }
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
                sshagent(['jenkins_agent']) {
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
}