pipeline {
  agent any
  tools {
      "org.jenkinsci.plugins.terraform.TerraformInstallation" "terraform"
  }
	parameters{
		srting(name:'WORKSPACE', defaultValue: 'development', description: 'setting up workspace for terraform')
	}
	environment {
		TF_HOME = tool('terraform')
		TP_LOG = "WARN"
		PATH = "$TF_HOME:$PATH"
		ACCESS_KEY = credentials('AWS_ACCESS_KEY')
		SECRET_KEY = credentials('AWS_SECRET_KEY')
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
 stage('Terraform plan') {
      steps {
        sh label: '', script: 'terraform plan'
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
  }
}
