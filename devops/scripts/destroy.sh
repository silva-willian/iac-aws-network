#!/bin/bash
check_sucessful(){
    if [ $? != 0 ];
    then
        echo "Error Execution"
        exit 1
    fi
}

login() {
    aws ecr get-login-password --region ${AWS_REGION} | \
        docker login --username AWS --password-stdin ${AWS_ACCOUNT_REGISTRY}.dkr.ecr.${AWS_REGION}.amazonaws.com
}

destroy() {
    docker run \
        -e AWS_ACCESS_KEY_ID="${AWS_ACCESS_KEY_ID}" \
        -e AWS_SECRET_ACCESS_KEY="${AWS_SECRET_ACCESS_KEY}" \
        -e AWS_REGION="${AWS_REGION}" \
        -e REMOTE_STATE_BUCKET="${REMOTE_STATE_BUCKET}" \
        -e REMOTE_STATE_FILE="${REMOTE_STATE_FILE}" \
        -e REMOTE_STATE_AWS_REGION="${REMOTE_STATE_AWS_REGION}" \
        -e ENV="${ENV}" \
        -e ENV_VERSION="${ENV_VERSION}" \
        -e PRODUCT="${PRODUCT}" \
        -e CREATED_BY="${CREATED_BY}" \
        -e OWNER="${OWNER}" \
        ${AWS_ACCOUNT_REGISTRY}.dkr.ecr.${AWS_REGION}.amazonaws.com/${PROJECT_NAME}:1.0.7-destroy
}

AWS_ACCOUNT_REGISTRY=$(aws sts get-caller-identity --output text |awk '{print $1}')
    check_sucessful

login
    check_sucessful

destroy
    check_sucessful