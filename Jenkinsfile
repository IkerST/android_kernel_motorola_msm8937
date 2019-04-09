pipeline {
  agent any
  stages {
    stage('Start Build (aljeter)') {
      steps {
        sh 'make ARCH=arm aljeter_defconfig && make ARCH=arm CROSS_COMPILE=../gcc-linaro-7.1.1/bin/arm-linux-gnueabihf-'
      }
    }
    stage('Copy zImage (aljeter)') {
      steps {
        sh 'cp arch/arm/boot/zImage kernel-aljeter-zImage'
      }
    }
    stage('Archive Artifacts (aljeter)') {
      steps {
        archiveArtifacts(artifacts: 'kernel-aljeter-zImage')
      }
    }
    stage('Clean (aljeter)') {
      steps {
        sh 'make ARCH=arm aljeter_defconfig && make clean'
      }
    }
    stage('Start Build (jeter)') {
      steps {
        sh 'make ARCH=arm jeter_defconfig && make ARCH=arm CROSS_COMPILE=../gcc-linaro-7.1.1/bin/arm-linux-gnueabihf-'
      }
    }
    stage('Copy zImage (jeter)') {
      steps {
        sh 'cp arch/arm/boot/zImage kernel-jeter-zImage'
      }
    }
    stage('Archive Artifacts (jeter)') {
      steps {
        archiveArtifacts(artifacts: 'kernel-jeter-zImage')
      }
    }
    stage('Clean (jeter)') {
      steps {
        sh 'make ARCH=arm jeter_defconfig && make clean'
      }
    }
  }
}
