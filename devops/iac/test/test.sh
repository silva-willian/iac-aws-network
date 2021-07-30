#!/bin/sh
check_sucessful(){
    if [ $? != 0 ];
    then
        echo "Error Execution"
        exit 1
    fi
}

init() {
    terraform init \
        -backend=true \
        -backend-config="bucket=${REMOTE_STATE_BUCKET}-${REMOTE_STATE_AWS_REGION}-${ENV}-${ENV_VERSION}" \
        -backend-config="key=${REMOTE_STATE_FILE}" \
        -backend-config="region=${REMOTE_STATE_AWS_REGION}"
}

validate() {
    terraform validate   
}

init
    check_sucessful

validate
    check_sucessful