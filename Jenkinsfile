pipeline {
    agent none

    tools {
        // Install the Maven version configured as "M3" and add it to the path.
        maven "mymaven"
    }
    
    environment{
        BUILD_SERVER_IP='ec2-user@172.31.33.147'
        IMAGE_NAME='devopstrainer/java-mvn-privaterepos'
    }

    stages {
        stage('Compile') {
            // agent {label "linux_slave"}
            agent any
            steps {              
              script{
                     echo "COMPILING"
                     sh "mvn compile"
              }             
            }
        stage('Test') {
            steps {
                echo "Testing the code"
            }
            }
        stage('Package') {
            steps {
                echo "Packaging the code"
            }
            }
        }
        }
        stage('containerise the packaging+push the image') {
            agent any
            steps {              

                script{
                     echo "Creating the package"
                sshagent(['slave2']) {
                sh "scp -o StrictHostKeyChecking=no server-script.sh ${BUILD_SERVER_IP}:/home/ec2-user"
                sh "ssh -o StrictHostKeyChecking=no ${BUILD_SERVER_IP} 'bash server-script.sh ${IMAGE_NAME} ${BUILD_NUMBER}'"
               
                
                }             
                }
            }            
        }

    }
}
