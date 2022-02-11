pipeline {
  agent {
    kubernetes {
      yaml '''
        apiVersion: v1
        kind: Pod
        spec:
          containers:
          - name: cli
            image: amazon/aws-cli
            command:
            - cat
            tty: true
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
        }
      }
    }

    stage('docker build') {
      steps{
        container('docker') {
          sh 'docker version'

          sh 'docker login --username AWS --password-stdin < mytoken.txt 529396670287.dkr.ecr.us-west-2.amazonaws.com'
          sh 'docker build -t 529396670287.dkr.ecr.us-west-2.amazonaws.com/trogaev-ecr-backend:v3 . -f ./src/CM.WeeklyTeamReport.WebAPI/Dockerfile'
          //sh 'docker tag weekly-team-report-html:v1 529396670287.dkr.ecr.us-west-2.amazonaws.com/trogaev-ecr:v1'
          sh 'docker push 529396670287.dkr.ecr.us-west-2.amazonaws.com/trogaev-ecr-backend:v3'

          sh 'docker build -t 529396670287.dkr.ecr.us-west-2.amazonaws.com/trogaev-ecr-backend-dacpack:v3 ./src/CM.WeeklyTeamReport.DB -f ./src/CM.WeeklyTeamReport.DB/Dockerfile'
          sh 'docker push 529396670287.dkr.ecr.us-west-2.amazonaws.com/trogaev-ecr-backend-dacpack:v3'

        }
      }
    }

  }
}
