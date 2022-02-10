pipeline {
  agent {
    kubernetes {
      yaml '''
        apiVersion: v1
        kind: Pod
        spec:
          containers:
          - name: docker
            image: docker:19.03.1-dind
            securityContext:
                privileged: true
            env:
              - name: DOCKER_TLS_CERTDIR
                value: ""
        '''
    }
  }
  stages {

    stage('cli') {
      steps {
        container('cli') {
          sh 'aws ecr get-login-password --region us-west-2 > mytoken.txt'
          sh 'aws ecr-private create-repository --repository-name trogaev-app-backend'
        }
      }
    }

    stage('docker build') {
      steps{
        container('docker') {
          sh 'docker version'

          sh 'docker login --username AWS --password-stdin < mytoken.txt 529396670287.dkr.ecr.us-west-2.amazonaws.com'
          sh 'docker build -t 529396670287.dkr.ecr.us-west-2.amazonaws.com/trogaev-ecr-backend:v1 ./src/CM.WeeklyTeamReport.WebAPI/'
          //sh 'docker tag weekly-team-report-html:v1 529396670287.dkr.ecr.us-west-2.amazonaws.com/trogaev-ecr:v1'
          sh 'docker push 529396670287.dkr.ecr.us-west-2.amazonaws.com/trogaev-ecr-backend:v1'
        }
      }
    }

  }
}