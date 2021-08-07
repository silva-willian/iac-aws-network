#!/bin/bash
check_sucessful(){
  if [ $? != 0 ];
  then
    echo "Error Execution"
    exit 1
  fi
}

test_build() {
    docker build -t ${PROJECT_NAME}-test:${VERSION} -f devops/iac/test/Dockerfile .
}

test_execute() {
    docker run --rm \
        -e AWS_ACCESS_KEY_ID="${AWS_ACCESS_KEY_ID}" \
        -e AWS_SECRET_ACCESS_KEY="${AWS_SECRET_ACCESS_KEY}" \
        -e AWS_REGION="${AWS_REGION}" \
        -e REMOTE_STATE_BUCKET="${REMOTE_STATE_BUCKET}" \
        -e REMOTE_STATE_FILE="${REMOTE_STATE_FILE}" \
        -e REMOTE_STATE_AWS_REGION="${REMOTE_STATE_AWS_REGION}" \
        -e ENV="all" \
        -e ENV_VERSION="v1" \
        -e PRODUCT="${PRODUCT}" \
        -e CREATED_BY="${CREATED_BY}" \
        -e OWNER="${OWNER}" \
        ${PROJECT_NAME}-test:${VERSION}
        check_sucessful

    docker rmi ${PROJECT_NAME}-test:${VERSION}
        check_sucessful        
}

VERSION="1.0.${GITHUB_RUN_NUMBER}"

test_build
    check_sucessful

test_execute
    check_sucessful
