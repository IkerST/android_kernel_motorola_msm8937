pipeline {
  agent any
  stages {
    stage('Start Build (aljeter)') {
      steps {
        sh 'make aljeter_defconfig && make ARCH=arm CROSS_COMPILE=../gcc-linaro-7.1.1/bin/arm-linux-gnueabihf-'
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
        sh 'make aljeter_defconfig && make clean'
      }
    }
    stage('Start Build (jeter)') {
      steps {
        sh 'make jeter_defconfig && make ARCH=arm CROSS_COMPILE=../gcc-linaro-7.1.1/bin/arm-linux-gnueabihf-'
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
        sh 'make jeter_defconfig && make clean'
      }
    }
     stage('Upload Release') {
      steps {
        dir(path: 'release') {
          unarchive mapping: ['*' : '.']
          withCredentials([
           string(credentialsId: 'TG_BOT_API', variable: 'TG_BOT_API'),
           string(credentialsId: 'GITHUB_API', variable: 'GIT_API_KEY')
          ]) {
            sh '''GIT_TAG=$(date +%d-%m-%y-%H-%M-%S) && \\
            pwd && eval $(ssh-agent -s) && \\
            ssh-add ~/.ssh/git && \\
            git clone git@github.com:IkerST/android_kernel_motorola_msm8937.git kernel.git && \\
            cd kernel.git && \\
            git tag $GIT_TAG && git push --tags && \\
            cd .. && rm -rf kernel.git && \\
            github-release release \\
      --security-token $GIT_API_KEY \\
      --user IkerST \\
      --repo android_kernel_motorola_msm8937 \\
      --tag $GIT_TAG \\
      --name "Kernel Moto G6 Play $GIT_TAG" \\
      --description "This is a kernel built for the Moto G6 Play" \\
            github-release upload \\
      --security-token $GIT_API_KEY \\
      --user IkerST \\
      --repo android_kernel_motorola_msm8937 \\
      --tag $GIT_TAG \\
      --name kernel-aljeter-zImage \\
      --file kernel-aljeter-zImage ; \\
      md5sum kernel-aljeter-zImage >> sums.md5sum \\
            github-release upload \\
      --security-token $GIT_API_KEY \\
      --user IkerST \\
      --repo android_kernel_motorola_msm8937 \\
      --tag $GIT_TAG \\
      --name kernel-jeter-zImage \\
      --file kernel-jeter-zImage ; \\
      md5sum kernel-jeter-zImage >> sums.md5sum \\
      github-release upload \\
      --security-token $GIT_API_KEY \\
      --user IkerST \\
      --repo android_kernel_motorola_msm8937 \\
      --tag $GIT_TAG \\
      --name sums.md5sum \\
      --file sums.md5sum ; \\
      RELEASE_URL=$(github-release info -u IkerST -r android_kernel_motorola_msm8937 -t $GIT_TAG -j | jq -r '.Releases[]|"\\(.html_url)"'); \\
      RELEASE_NAME=$(github-release info -u IkerST -r android_kernel_motorola_msm8937 -t $GIT_TAG -j | jq -r '.Releases[]|"\\(.name)"'); \\
      curl "https://api.telegram.org/bot${TG_BOT_API}/sendMessage" -d "{ \\"chat_id\\":\\"-1001200278549\\", \\"text\\":\\"New Release ${RELEASE_NAME}: [github](${RELEASE_URL})\\", \\"parse_mode\\":\\"markdown\\"}" -H "Content-Type: application/json" -s > /dev/null
      '''
          }
          deleteDir()
        }
      }
    }
  }
}
