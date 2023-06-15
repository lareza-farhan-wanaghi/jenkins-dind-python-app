node {
    checkout scm
    stage('Build') {
        docker.image('python:2-alpine').inside {
            sh 'echo test2'
            sh 'python -m py_compile sources/add2vals.py sources/calc.py'
            stash(name: 'compiled-results', includes: 'sources/*.py*')
        }
    }
    
    stage('Test') {
        docker.image('qnib/pytest').inside {
            sh 'py.test --verbose --junit-xml test-reports/results.xml sources/test_calc.py'
        }
    }


    stage('Manual Approval') {
        // input message: 'Lanjutkan ke tahap Deploy?'
    }

    stage('Deploy') {
        unstash('compiled-results')
        withCredentials([usernamePassword(credentialsId: 'docker', passwordVariable: 'PASS', usernameVariable: 'USER')]) {
            sh 'docker build -t 890890123890/simple-python-app .'
            sh "echo $PASS | docker login -u $USER --password-stdin"
            sh 'docker push 890890123890/simple-python-app'
        }
        
        sshagent(['ec2-app']) {
            def cmd = 'sudo docker run --name app -p 3000:3000 -d 890890123890/simple-python-app:latest'
            sh "ssh -o StrictHostKeyChecking=no ubuntu@18.136.105.164 ${cmd}"
        }

        // sleep 60

        sshagent(['ec2-app']) {
            def cmd = 'sudo docker stop app && docker rm app'
            sh "ssh -o StrictHostKeyChecking=no ubuntu@18.136.105.164 ${cmd}"
        }
    }
}
