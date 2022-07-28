pipeline {
  agent any
  
  parameters {
    booleanParam(name: 'runDefault', defaultValue: true, description: 'If this checked: Hello World!')
    string(name: 'UserNameToPrint', defaultValue: '', description: 'If this specified and runDefault is false: Hello <NAME>!')    
  
  stages {
    stage('Docker Build') {
      steps {
        sh "docker build --build-arg username="" -t ./.:${env.BUILD_NUMBER} ."
      }
    }
    stage('Docker Push') {
      steps {
        withCredentials([usernamePassword(credentialsId: 'dockerhub', passwordVariable: 'dockerHubPassword', usernameVariable: 'dockerHubUser')]) {
          sh "docker login -u ${env.dockerHubUser} -p ${env.dockerHubPassword}"
          sh "docker push ./.:${env.BUILD_NUMBER}"
          sh "docker push ./.:latest"
        }
      }
    }
    stage('Apply Kubernetes Files') {
      steps {
          withKubeConfig([credentialsId: 'kubeconfig']) {
          sh 'helm install --set name="" hello ./hello'
          sh 'kubectl logs ... > ....'
        }
      }
  }
}
post {
  always {
    cleanWs notFailBuild: true
  }
}
}
