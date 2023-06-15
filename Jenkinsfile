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
        withEnv(['VOLUME=$(pwd)/sources:/src', 'IMAGE=cdrx/pyinstaller-linux:python2']) {
            dir(env.BUILD_ID) {
                unstash('compiled-results')
                sh "docker run --rm -v ${env.VOLUME} ${env.IMAGE} 'pyinstaller -F add2vals.py'"
                // sleep 60
                sh "echo test2"
                sh 'sources/dist/add2vals 1 2'  // Test the deployed executable
      
            }
        }
    }
}
