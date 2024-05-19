pipeline {
    agent none

    tools {
        // Install the Maven version configured as "M3" and add it to the path.
        maven "mymaven"
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

        
        stage('unit_test') {
            agent any
            steps {

                script{
                        echo "testing code"
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
            // agent {label 'micro_slave_3'}
            // hello
            steps {
                script{
                        echo "packaging code"
                        sh "mvn package"

    
                }
            }
        }



        
    }
}
