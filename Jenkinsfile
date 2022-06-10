pipeline {
  agent any
  tools {
      terraform "Terraform1.0.0"
  }

  stages {
    stage('Git Checkout') {
      steps {
        git credentialsId: '16**-**-**-**-**cb', url: 'https://git-codecommit.us-west-2.amazonaws.com/v1/repos/TerraformJenkins'
      }
    }
    stage('Terraform Init') {
      steps {
        sh label: '', script: 'terraform init'
      }
    }
	stage('Terraform validate') {
      steps {
        sh label: '', script: 'terraform validate'
      }
    }
post {
  failure {
    mail to: 'gajulapallen@quinnox.com',
      subject: "Terraform validation: ${currentBuild.fullDisplayName}",
      body: "Terraform code validation got filed please check in this build ${env.BUILD_URL}"
  }
}
    stage('Terraform apply') {
      steps {
        sh label: '', script: 'terraform apply --auto-approve'
      }
    }
post {
  success {
    mail to: 'gajulapallen@quinnox.com',
      subject: "EC2 instance got created",
      body: "EC2 instance got created secussfully"
  }
}
	stage('Terraform destroy') {
      steps {
        sh label: '', script: 'terraform destroy'
      }
    }
	post {
  success {
    mail to: 'gajulapallen@quinnox.com',
      subject: "EC2 instance got teriminated",
      body: "EC2 instance got teriminated secussfully"
  }
}
  }
}
