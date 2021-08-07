#!/bin/bash
check_sucessful(){
    if [ $? != 0 ];
    then
        echo "Error Execution"
        exit 1
    fi
}

create_repository() {
  
  EXISTS=$(echo `aws ecr describe-repositories --repository-name $PROJECT_NAME --region ${AWS_REGION} |grep repositoryName | sed -e 's/\"//g' | sed -e 's/.*repositoryName://' | sed -e 's/\,//g'`)

  if [ -z "$EXISTS" ];
  then
    aws ecr create-repository \
      --repository-name "$PROJECT_NAME" \
      --image-tag-mutability IMMUTABLE \
      --image-scanning-configuration scanOnPush=true
  fi
}

login() {
    aws ecr get-login-password --region ${AWS_REGION} | \
        docker login --username AWS --password-stdin ${AWS_ACCOUNT_REGISTRY}.dkr.ecr.${AWS_REGION}.amazonaws.com
}

build_images() {
    build_push ${PROJECT_NAME}-deploy devops/iac/deploy/Dockerfile
        check_sucessful

    build_push ${PROJECT_NAME}-destroy devops/iac/destroy/Dockerfile
        check_sucessful
}

build_push(){

    docker build -t ${AWS_ACCOUNT_REGISTRY}.dkr.ecr.${AWS_REGION}.amazonaws.com/$1:${VERSION} -f $2 .
        check_sucessful

    docker push ${AWS_ACCOUNT_REGISTRY}.dkr.ecr.${AWS_REGION}.amazonaws.com/$1:${VERSION}
        check_sucessful

    docker rmi ${AWS_ACCOUNT_REGISTRY}.dkr.ecr.${AWS_REGION}.amazonaws.com/$1:${VERSION}
        check_sucessful
}

AWS_ACCOUNT_REGISTRY=$(aws sts get-caller-identity --output text |awk '{print $1}')
    check_sucessful

VERSION="1.0.${GITHUB_RUN_NUMBER}"

create_repository
    check_sucessful

login
    check_sucessful

build_images
    check_sucessful