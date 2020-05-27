properties([pipelineTriggers([githubPush()])])

pipeline {
    agent {
        label 'master'
    }
    environment {
        branchName = "master"
    }
    stages {
        stage("Checkout") {
            steps {
                checkout([
                    $class: 'GitSCM',
                    branches: [[name: branchName]],
                    userRemoteConfigs: [[
                        url: 'https://github.com/IneyQQ/task2.git',
                        credentialsId: '',
                    ]]
                ])
            }
        }
        stage("Deploy") {
            steps {
                sshagent(credentials : ['ubuntu-slave']) {
                    withCredentials([string(credentialsId: 'task-server-password', variable: 'PASSWD'),
                                    string(credentialsId: 'task-server-ip', variable: 'IP')]) {
                        sh """\
                        ssh -o StrictHostKeyChecking=no project1@${IP} <<'EOF'
                            set -xe
                            cd /home/project1
                            git fetch
                            out=\$(git diff --name-only ${branchName} origin/${branchName} | egrep "^data/.*\$" || true)
                            if [ "\$out" != "" ]; then
                                git pull
                                echo "${PASSWD}" | sudo -S systemctl restart task-project
                            fi
                        EOF
                        """.stripIndent()
                    }
                }
            }
        }
    }
}
