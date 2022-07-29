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
    string(name: 'dockerImageVersion', defaultValue: 'latest', description: 'Docker image\'s version to deploy')
    string(name: 'clusterToDeploy', defaultValue: 'docker-desktop', description: 'Kubernetes cluster\'s name to deploy')
  }
  
//if default --> usernameToPrint = ''

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
          withCredentials([file(credentialsId: "${params.clusterToDeploy}-kubeconfig", variable: 'kubeconfig')]) {
            sh "cp \$kubeconfig /tmp/config"
          }
        }
      }
    }
    
    stage('Helm Deploy') {
      steps {
        script {
          withEnv(["KUBECONFIG=/tmp/config"]) {
            sh "helm delete hello"
            sh "helm install --set dockerImageVersion=${params.dockerImageVersion} hello ./hello"
          }
        }
      }
    }

    stage('Collect Container Logs') {
      steps {
        script {
          withEnv(["KUBECONFIG=/tmp/config"]) {
            sh "echo 'Waiting for container creation...' && sleep 20"
            sh "for pod in \$(kubectl get po --output=jsonpath={.items..metadata.name}); do kubectl logs \$pod; done > docker-logs.txt"
            archiveArtifacts artifacts: 'docker-logs.txt'
          }
        }
      }
    }
  }

post {
  always {
    cleanWs notFailBuild: true
    sh "rm -rf /tmp/config"
    sh "docker system prune -a -f"    
  }
}
}
