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
        withCredentials([usernamePassword(credentialsId: '9b4ff735-cbfe-41b3-9052-064bd5d439cd', passwordVariable: 'PASS', usernameVariable: 'USER')]) {
            sh 'docker build -t 890890123890/simple-python-app .'
            sh "echo $PASS | docker login -u $USER --password-stdin"
            sh 'docker push 890890123890/simple-python-app'
        }
        
        sshagent(['e0195529-4da9-4a6b-ad0a-05a28a309c8a']) {
            def cmd = 'docker run --name app -p 3000:3000 -d 890890123890/simple-python-app:latest'
            sh "ssh -o StrictHostKeyChecking=no ubuntu@18.136.105.164 ${cmd}"
        }

        // sleep 60

        sshagent(['e0195529-4da9-4a6b-ad0a-05a28a309c8a']) {
            def cmd = 'docker rm app'
            sh "ssh -o StrictHostKeyChecking=no ubuntu@18.136.105.164 ${cmd}"
        }
    }
}
