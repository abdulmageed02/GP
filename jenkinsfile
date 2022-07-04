pipeline {

    agent any

    stages {
        stage('Build') {
            steps {
               withCredentials([usernamePassword(credentialsId: 'MYSQL', passwordVariable: 'PASS', usernameVariable: 'USER')]) {
               sh "chmod +x ./kubernetes/secrets-configmaps/mysql-cred.sh"
                sh "./kubernetes/secrets-configmaps/mysql-cred.sh"
                sh "kubectl apply -f kubernetes/pods-deployments"
                sh "kubectl apply -f kubernetes/svcs"
}


            }


        }
    }
}
