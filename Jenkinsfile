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
            sshagent(['jenkins_agent']) {
                    script {
                        sh 'echo $TF_VAR_libvirt_uri'
                        sh 'echo $(TF_VAR_libvirt_uri)'
                        sh 'terraform plan -out=tfplan -var "libvirt_uri=$(TF_VAR_libvirt_uri)"'
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