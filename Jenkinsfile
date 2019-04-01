pipeline {
  agent any
  stages {
    stage('Start Build (aljeter)') {
      steps {
        sh ' echo -n "5\\n" | ./make.sh'
      }
    }
    stage('Rename Zip (aljeter)') {
      steps {
        sh 'mv lsm-anykernel.zip $(date date +%d-%m-%y-%H-%M-%S)-aljeter.zip'
      }
    }
    stage('Upload Github (aljeter)') {
      steps {
        sh 'echo "Placeholder"'
      }
    }
    stage('Clean (aljeter)') {
      steps {
        sh 'make clean'
      }
    }
    stage('Start Build (jeter)') {
      steps {
        sh ' echo -n "4\\n" | ./make.sh'
      }
    }
    stage('Rename Zip (jeter)') {
      steps {
        sh 'mv lsm-anykernel.zip $(date date +%d-%m-%y-%H-%M-%S)-jeter.zip'
      }
    }
    stage('Upload Github (jeter)') {
      steps {
        sh 'echo "Placeholder"'
      }
    }
    stage('Clean (jeter)') {
      steps {
        sh 'make clean'
      }
    }
  }
}