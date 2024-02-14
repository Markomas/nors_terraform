pipeline {
    agent any

    options {
       ansiColor('xterm')
    }

    stages {
        stage('Terraform init') {
            steps {
                sh 'terraform init'
            }
        }

        stage('Terraform Plan') {
            steps {
                sshagent(['jenkins_agent']) {
                    script {
                        sh "terraform plan -out=tfplan"
                    }
                }
            }
        }
//         stage('Terraform apply') {
//              steps {
//                 sshagent(['jenkins_agent']) {
//                     sh 'terraform apply --auto-approve tfplan'
//                 }
//              }
//         }
        stage('Upload State to backup') {
            steps {
                sshPublisher(
                  continueOnError: false,
                  failOnError: true,
                  publishers: [
                    sshPublisherDesc(
                      configName: "baubilas",
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