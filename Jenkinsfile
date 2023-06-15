node {
    checkout scm
    stage('Build') {
        docker.image('python:2-alpine').inside {
            sh 'python -m py_compile sources/add2vals.py sources/calc.py'
        }
    }
    
    stage('Test') {
        docker.image('qnib/pytest').inside {
            sh 'py.test --verbose --junit-xml test-reports/results.xml sources/test_calc.py'
        }
    }


    stage('Manual Approval') {
        input message: 'Lanjutkan ke tahap Deploy?'
    }

    stage('Deploy') {
        withCredentials([usernamePassword(credentialsId: 'docker', passwordVariable: 'PASS', usernameVariable: 'USER')]) {
            sh 'cat Dockerfile'
            sh 'docker build -t 890890123890/simple-python-app .'
            sh "echo $PASS | docker login -u $USER --password-stdin"
            sh 'docker push 890890123890/simple-python-app'
        }
        
        sshagent(['ec2-app']) {
            def cmd = 'sudo docker pull 890890123890/simple-python-app:latest && sudo docker run --name app -p 3000:3000 -d 890890123890/simple-python-app:latest'
            sh "ssh -o StrictHostKeyChecking=no ubuntu@18.136.105.164 '${cmd}'"
        }

        sleep 60

        sshagent(['ec2-app']) {
            def cmd = 'sudo docker rm app'
            sh "ssh -o StrictHostKeyChecking=no ubuntu@18.136.105.164 ${cmd}"
        }
    }
}
