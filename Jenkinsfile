pipeline {

  agent any

  parameters {
    string(name: 'branchToBuild', defaultValue: 'main', description: 'Branch to build')
    booleanParam(name: 'runDefault', defaultValue: true, description: 'If this checked: Hello World!')
    string(name: 'userNameToPrint', defaultValue: '', description: 'If this specified and runDefault is false: Hello <NAME>!')
    string(name: 'dockerImageVersion', defaultValue: 'latest', description: 'Docker image\'s version to deploy')
    choice(name: 'clusterToDeploy', choices: ['docker-desktop'], description: 'Kubernetes cluster\'s name to deploy')
  }
  
  environment {
    def gitRepo = 'https://github.com/lugosidomotor/devops-assessment.git'
    def dockerImage = 'hello'
    def dockerRepository = 'ldomotor'
  }

  stages {      
    stage('Checkout Source') {
      steps {
        git branch: params.branchToBuild, url: gitRepo
      }
    }

    stage('Docker Build') {
      steps {
        sh """
          set -x
          if [ ${params.runDefault} = true ]; then
            docker build -t ${env.dockerRepository}/${env.dockerImage}:${env.BUILD_NUMBER} -t ${env.dockerRepository}/${env.dockerImage}:latest .
          else
            docker build --build-arg username='${params.userNameToPrint}' -t ${env.dockerRepository}/${env.dockerImage}:${env.BUILD_NUMBER} -t ${env.dockerRepository}/${env.dockerImage}:latest .
          fi
          """
      }
    }

    stage('Docker Login') {
      steps {
        withCredentials([usernamePassword(credentialsId: 'dockerHub', passwordVariable: 'dockerHubPassword', usernameVariable: 'dockerHubUser')]) {
          sh "docker login -u ${env.dockerHubUser} -p ${env.dockerHubPassword}"
        }
      }
    }

    stage('Docker Push') {
      steps {
        sh "docker image push --all-tags ${env.dockerRepository}/${env.dockerImage}"
      }
    }

    stage('Kubernetes Config') {
      steps {
        withCredentials([file(credentialsId: "${params.clusterToDeploy}-kubeconfig", variable: 'kubeconfig')]) {
          sh "cp \$kubeconfig /tmp/config"
        }
      }
    }
    
    stage('Helm Deploy') {
      steps {
        withEnv(["KUBECONFIG=/tmp/config"]) {
          sh "helm upgrade --install --force --set dockerImageVersion=${params.dockerImageVersion} hello ./hello"
        }
      }
    }

    stage('Collect Container Logs') {
      steps {
        withEnv(["KUBECONFIG=/tmp/config"]) {
          sh "echo 'Waiting for container creation...' && sleep 10"
          sh "for pod in \$(kubectl get po --output=jsonpath={.items..metadata.name}); do kubectl logs \$pod; done > docker-logs.txt"
          archiveArtifacts artifacts: 'docker-logs.txt'
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
