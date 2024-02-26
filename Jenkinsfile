pipeline {
   agent none
   tools{
         jdk 'myjava'
         maven 'mymaven'
   }
   environment{
       BUILD_SERVER_IP='ec2-user@172.31.9.109'
       IMAGE_NAME='devopstrainer/java-mvn-privaterepos:$BUILD_NUMBER'
   }
    stages {
        stage('Compile') {
           agent any
            steps {
              script{
                  echo "BUILDING THE CODE"
                  sh 'mvn compile'
              }
            }
            }
        stage('UnitTest') {
        agent any
        steps {
            script{
              echo "TESTING THE CODE"
              sh "mvn test"
              }
            }
            post{
                always{
                    junit 'target/surefire-reports/*.xml'
                }
            }
            }
        stage('PACKAGE+BUILD DOCKERIMAGE AND PUSH TO DOKCERHUB') {
            agent any            
            steps {
                script{
                sshagent(['slave2']) {
                withCredentials([usernamePassword(credentialsId: 'docker-hub', passwordVariable: 'PASSWORD', usernameVariable: 'USERNAME')]) {
                echo "Packaging the apps"
                sh "scp -o StrictHostKeyChecking=no server-script.sh ${BUILD_SERVER_IP}:/home/ec2-user"
                sh "ssh -o StrictHostKeyChecking=no ${BUILD_SERVER_IP} 'bash ~/server-script.sh'"
                sh "ssh ${BUILD_SERVER_IP} sudo docker build -t ${IMAGE_NAME} /home/ec2-user/addressbook"
                sh "ssh ${BUILD_SERVER_IP} sudo docker login -u $USERNAME -p $PASSWORD"
                sh "ssh ${BUILD_SERVER_IP} sudo docker push ${IMAGE_NAME}"
              }
            }
            }
        }
        }
       stage('Provision the server with TF'){
            environment{
                   AWS_ACCESS_KEY_ID =credentials("ACCESS_KEY")
                   AWS_SECRET_ACCESS_KEY=credentials("SECRET_ACCESS_KEY")
            }
           agent any
           steps{
               script{
                   echo "RUN THE TF Code"
                   dir('terraform'){
                       sh "terraform init"
                       sh "terraform apply --auto-approve"
                    EC2_PUBLIC_IP=sh(
                        script: "terraform output ec2-ip",
                        returnStdout: true
                    ).trim()
                   }
                                     
               }
           }
       }
       stage("Deploy on EC2 instance created by TF"){
          agent any
           steps{
               script{
                   echo "Deployin on the instance"
                    echo "${EC2_PUBLIC_IP}"
                     sshagent(['slave2']) {
                withCredentials([usernamePassword(credentialsId: 'docker-hub', passwordVariable: 'PASSWORD', usernameVariable: 'USERNAME')]) {
                      sh "ssh -o StrictHostKeyChecking=no ec2-user@${EC2_PUBLIC_IP} sudo docker login -u $USERNAME -p $PASSWORD"
                      sh "ssh ec2-user@${EC2_PUBLIC_IP} sudo docker run -itd -p 8080:8080 ${IMAGE_NAME}"
                     
                }
            }
            }
                }
                }
                   }
}