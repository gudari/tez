pipeline {
    agent {
        kubernetes {
            yaml """
kind: Pod
metadata:
  name: default
spec:
  containers:
  - name: jnlp
    image: gudari/jenkins-agent:4.9-hadoop-arm64
    imagePullPolicy: Always
"""
        }
    }
    environment {
        GITHUB_ORGANIZATION = 'gudari'
        GITHUB_REPO         = 'tez'
        HADOOP_VERSION      = '3.3.1'
        VERSION             = '0.10.1'
        GITHUB_TOKEN        = credentials('github_token')
    }
    stages {
        stage('Build') {
            steps {
                sh ("mvn -Dmaven.repo.local=${HOME}/.m2/repository package -DskipTests=true -Dmaven.javadoc.skip=true")

                sh ("./create_release.sh $GITHUB_ORGANIZATION $GITHUB_REPO $HADOOP_VERSION $VERSION $GITHUB_TOKEN")
            }
        }
    }
}
