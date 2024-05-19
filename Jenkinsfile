pipeline {
    agent any

    tools {
        // Install the Maven version configured as "M3" and add it to the path.
        maven "mymaven"
    }

    stages {
        stage('Compile') {
            steps {
                script{
                    echo "compiling code"
                    sh "mvn compile"

    
                }
            }
        }

        
        stage('unit_test') {
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
            steps {
                script{
                        echo "packaging code"
                        sh "mvn package"

    
                }
            }
        }



        
    }
}
