pipeline {
  agent any
  stages {
    stage('Submodules') {
      steps{
        sh 'bash submodules.sh'
      }
    }
    stage('Start Build (aljeter)') {
      steps {
        sh 'make ARCH=arm aljeter_defconfig && make -j8 ARCH=arm CROSS_COMPILE=../gcc-linaro-7.1.1/bin/arm-linux-gnueabihf-'
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
    stage('Make modules (aljeter)') {
      steps {
        sh 'make ARCH=arm aljeter_defconfig && make -j8 modules_install INSTALL_MOD_PATH=./kernel_modules_aljeter/ ARCH=arm CROSS_COMPILE=../gcc-linaro-7.1.1/bin/arm-linux-gnueabihf- '
      }
    }
    stage('Compress modules (aljeter)') {
      steps {
        sh 'tar -cv -I pigz -f kernel_modules_aljeter.tar.gz  kernel_modules_aljeter/*'
      }
    }
    stage('Archive Artifacts (aljeter) - modules') {
      steps {
        archiveArtifacts(artifacts: 'kernel_modules_aljeter.tar.gz')
      }
    }
    stage('Clean (aljeter)') {
      steps {
        sh 'make ARCH=arm aljeter_defconfig && make clean'
      }
    }
    stage('Start Build (jeter)') {
      steps {
        sh 'make ARCH=arm jeter_defconfig && make -j8 ARCH=arm CROSS_COMPILE=../gcc-linaro-7.1.1/bin/arm-linux-gnueabihf-'
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
    stage('Make modules (jeter)') {
      steps {
        sh 'make ARCH=arm jeter_defconfig && make -j8 modules_install INSTALL_MOD_PATH=./kernel_modules_jeter/ ARCH=arm CROSS_COMPILE=../gcc-linaro-7.1.1/bin/arm-linux-gnueabihf- '
      }
    }
    stage('Compress modules (jeter)') {
      steps {
        sh 'tar -cv -I pigz -f kernel_modules_jeter.tar.gz  kernel_modules_jeter/*'
      }
    }
    stage('Archive Artifacts (jeter) - modules') {
      steps {
        archiveArtifacts(artifacts: 'kernel_modules_jeter.tar.gz')
      }
    }
    stage('Clean (jeter)') {
      steps {
        sh 'make ARCH=arm jeter_defconfig && make clean'
      }
    }
  }
}
