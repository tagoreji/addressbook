pipeline {
    agent none

    tools {
        // Install the Maven version configured as "M3" and add it to the path.
        maven "mymaven"
    }
    environment{
        BUILD_SERVER = "ec2-user@172.31.34.106"
    }

    stages {
        stage('Compile') {
            agent any
            steps {
                script{
                    echo "compiling code"
                    sh "mvn compile"

    
                }
            }
        }

        
        stage('unit_test') {   // running on slave2 via ssh-agent
            agent any
            steps {
                script{                      
                        sh "mvn test"

                }
            }

            post{
                always{
                    junit 'target/surefire-reports/*.xml'

                }
            }
        }


        stage('package') {
            agent any
            // agent {label 'micro_slave_3'}  manual connection
            //  OM NAMAH SHIVAAY
            steps {
                script{
                     sshagent(['SLAVE_2']) {
                        echo "testing code"
                        sh "scp  -o StrictHostKeyChecking=no server-config.sh ${BUILD_SERVER}:/home/ec2-user"
                        sh "ssh  -o StrictHostKeyChecking=no ${BUILD_SERVER} 'bash -s && chmod +x server-config.sh && ./server-config.sh'"
                }
                        echo "packaging code"
                        sh "mvn package"

    
                }
            }
        }



        
    }
}
