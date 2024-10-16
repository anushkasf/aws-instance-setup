timestamps {
    node {
        def tfHome = tool name: 'Terraform'
        env.PATH = "${tfHome}:${env.PATH}"
        env.SLACK_CHANNEL = 'cx-devops'

        try {
            def scmVars
            stage('Checkout') {
                scmVars = checkout(scm)
                env.GIT_URL = scmVars.GIT_URL
            }
            createAllHosts()
        }
        catch (Throwable e) {
            handleFailure(e)
        } 
        finally {
            cleanWs()
        }
    }
}

def createAllHosts() {
    stage('create nonprod hosts"') {
        def nonprodhosts = ["sympl-winserv", "sympl-ubuntu"]
        def nonprodparallelstages = nonprodhosts.collectEntries {
            ["${it}" : {createHost(true,"host/nonprod/","${it}")}]
        }
        parallel nonprodparallelstages
    }

    stage('create prod hosts"') {
        def prodhosts = ["sympl-winserv", "sympl-ubuntu"]
        def prodparallelstages = prodhosts.collectEntries {
            ["${it}" : {createHost(true,"host/prod/","${it}")}]
        }
        parallel prodparallelstages
    }
}

def createHost(def isParallel, def awsAccountPath, def hostName) {
    node {
        def varPath = awsAccountPath + hostName
        def pathParts = varPath.split('/')

        echo "Path parts - ${pathParts}"

        def accountName = pathParts[0]
        def environment = pathParts[1]

        def useCrossAccount = true
        def accountId
        if(accountName == 'cx-devops') {
            if(environment == 'prod') {
                accountId = '1111111111111'
            } else {
                accountId = '2222222222222'
            }
        } else if(accountName == 'cx-shop') {
            if(environment == 'prod') {
                accountId = '3333333333333'
            } else {
                useCrossAccount = false
            }
        }

        if (useCrossAccount) {
            echo "Attempting to assume AWS role for account: ${accountId}"

            try {
                withAWS(role: "arn:aws:iam::${accountId}:role/Cross-Account", roleAccount: accountId) {
                    runTerraformTasks(varPath, hostName)
                }
            } catch (Exception e) {
                echo "Error occurred: ${e.getMessage()}"
            }
        } else {
            runTerraformTasks(varPath, hostName)
        }
    }
}

def runTerraformTasks(def varPath, def hostName) {
    def scmVars = checkout(scm)
    env.GIT_URL = scmVars.GIT_URL
    def workingDir = "."

    echo "Creating host for ${hostName}"
    lock("cx-rds-db-${hostName}") {
        def tfHome = tool name: 'Terraform'
        env.PATH = "${tfHome}:${env.PATH}"

        dir(workingDir) {
            sh "rm -rf .terraform*"
            sh "terraform --version"
            sh "terraform init -backend-config=vars/${varPath}/backend.hcl"
            sh "terraform plan -var-file vars/${varPath}/vars.tfvars"
            sh "terraform apply -auto-approve -var-file vars/${varPath}/vars.tfvars"
        }

        def privateIp = sh(script: "terraform output -raw private_ip", returnStdout: true).trim()
        notifySuccess(privateIp)
    }
}

def notifySuccess(def privateIp) {
    wrap([$class: 'BuildUser']) {
        slackSend(channel: "${env.SLACK_CHANNEL}",
            message: "NonProd Host Created Successfully\nIP: ${privateIp}\nStarted by ${BUILD_USER}\nRun: ${env.JOB_NAME} ${env.BUILD_NUMBER}\nJob URL: (<${env.RUN_DISPLAY_URL}|Open>)",
            color: "$env.SLACK_GREEN")
    }
}

def handleFailure(e) {
    print(e)
    wrap([$class: 'BuildUser']) {
        slackSend channel: "${env.SLACK_CHANNEL}",
        message: "NonProd Host Creation Failed\nStarted by ${BUILD_USER}\nRun: ${env.JOB_NAME} ${env.BUILD_NUMBER}\nJob URL: (<${env.RUN_DISPLAY_URL}|Open>)",
        color: "$env.SLACK_RED"
    }
}
