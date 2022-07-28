pipeline {

  agent any

  environment {
    def gitRepo = 'https://github.com/lugosidomotor/devops-assessment.git'
    def dockerImage = 'hello'
    def dockerRepository = 'ldomotor'
  }

  parameters {
    string(name: 'branchToBuild', defaultValue: 'main', description: 'Branch to build')
    booleanParam(name: 'runDefault', defaultValue: true, description: 'If this checked: Hello World!')
    string(name: 'UserNameToPrint', defaultValue: '', description: 'If this specified and runDefault is false: Hello <NAME>!')
  }
  
  stages {
      
    stage('Checkout Source') {
      steps {
        git branch: params.branchToBuild, url: gitRepo
      }
    }

    stage('Docker Build') {
      steps {
        script {
          sh "docker build --build-arg username='${params.UserNameToPrint}' -t ${env.dockerRepository}/${env.dockerImage}:${env.BUILD_NUMBER} -t ${env.dockerRepository}/${env.dockerImage}:latest ."
        }
      }
    }

    stage('Docker Login') {
      steps {
        script {
          withCredentials([usernamePassword(credentialsId: 'dockerHub', passwordVariable: 'dockerHubPassword', usernameVariable: 'dockerHubUser')]) {
            sh "docker login -u ${env.dockerHubUser} -p ${env.dockerHubPassword}"
          }
        }
      }
    }

    stage('Docker Push') {
      steps {
        script {
          sh "docker image push --all-tags ${env.dockerRepository}/${env.dockerImage}"
        }
      }
    }

    stage('Kubernetes Config') {
      steps {
        script {
          withCredentials([file(credentialsId: 'kubeconfig', variable: 'kubeconfig')]) {
            sh "cp \$kubeconfig /tmp/config"
          }
        }
      }
    }
    
    stage('Helm Deploy') {
      steps {
        script {
          withEnv(["KUBECONFIG=/tmp/config"]) {
            sh "helm install --set name=${params.UserNameToPrint} hello ./hello"
          }
        }
      }
    }

    stage('Collect Container Logs') {
      steps {
        script {
          withEnv(["KUBECONFIG=/tmp/config"]) {
            sh "..."
          }
        }
      }
    }

post {
  always {
    cleanWs notFailBuild: true
    //TODO
    //delete kubeconfig
    //delete docker images
    //implement default
  }
}
}
