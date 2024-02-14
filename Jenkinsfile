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
                ftpPublisher alwaysPublishFromMaster: true, continueOnError: false, failOnError: false, publishers: [
                    [configName: 'bubilas', transfers: [
                        [asciiMode: false, cleanRemote: false, excludes: '', flatten: false, makeEmptyDirs: false, noDefaultExcludes: false, patternSeparator: '[, ]+', remoteDirectorySDF: false, removePrefix: '', sourceFiles: '**.tfstate']
                    ], usePromotionTimestamp: false, useWorkspaceInPromotion: false, verbose: true]
                ]
            }
        }
    }
}