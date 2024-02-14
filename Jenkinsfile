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

        stage('Terraform apply') {
             steps {
                sshagent(['jenkins_agent']) {
                    sh 'terraform apply --auto-approve tfplan'
                }
             }
        }

        stage('Upload State to backup') {
            steps {
                ftpPublisher alwaysPublishFromMaster: true, masterNodeName: '', paramPublish: [parameterName:""], continueOnError: false, failOnError: false, publishers: [
                    [configName: 'bubilas', transfers: [
                        [asciiMode: false, cleanRemote: false, excludes: '', flatten: false, makeEmptyDirs: false, noDefaultExcludes: false, patternSeparator: '[, ]+', remoteDirectory:'nors_terraform', remoteDirectorySDF: false, removePrefix: '', sourceFiles: '**.tfstate']
                    ], usePromotionTimestamp: false, useWorkspaceInPromotion: false, verbose: true]
                ]
            }
        }

        stage('Save artefacts') {
            steps {
                archiveArtifacts(artifacts: 'terraform.tfstate', fingerprint: true)
                archiveArtifacts(artifacts: 'nors_news_ansible_inventory.tfstate', fingerprint: true, onlyIfSuccessful: true)
            }
        }
    }
}