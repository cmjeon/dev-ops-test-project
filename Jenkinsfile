pipeline{
    agent any
    environment {
        SCRIPT_PATH = '/var/jenkins_home/dev-ops-test-project'
    }
    tools {
        gradle 'gradle 8.4'
    }
    stages{
        stage('Select Environment') {
            steps {
                script {
                    if (env.BRANCH_NAME == 'prod') {
                        env.DEPLOY_PROFILE = 'prod'
                        env.CONFIG_CREDENTIALS = 'application-prod'
                    } else if (env.BRANCH_NAME == 'dev') {
                        env.DEPLOY_PROFILE = 'dev'
                        env.CONFIG_CREDENTIALS = 'application-dev'
                    } else {
                        error "Unsupported branch for deployment: ${env.BRANCH_NAME}"
                    }
                }
            }
        }
        stage('Checkout') {
            steps {
                checkout scm
            }
        }
        stage('Prepare'){
            steps {
                sh 'gradle clean'
            }
        }
        stage('Replace Properties') {
            steps {
                withCredentials([file(credentialsId: "${env.CONFIG_CREDENTIALS}", variable: 'APP_CONFIG')]) {
                    sh "cp \$APP_CONFIG ./src/main/resources/application-${env.DEPLOY_PROFILE}.yml"
                }
            }
        }
        stage('Build') {
            steps {
                sh 'gradle build -x test'
            }
        }
        stage('Test') {
            steps {
                sh 'gradle test'
            }
        }
        stage('Deploy') {
            steps {
                withEnv(["SPRING_PROFILES_ACTIVE=${env.DEPLOY_PROFILE}"]) {
                    sh '''
                        cp ./docker/docker-compose.yml ${SCRIPT_PATH}
                        cp ./docker/Dockerfile ${SCRIPT_PATH}
                        cp ./scripts/deploy.sh ${SCRIPT_PATH}
                        cp ./build/libs/*.jar ${SCRIPT_PATH}
                        chmod +x ${SCRIPT_PATH}/deploy.sh
                        ${SCRIPT_PATH}/deploy.sh
                    '''
                }
            }
        }
    }
}
