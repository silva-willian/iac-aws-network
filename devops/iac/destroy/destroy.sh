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

destroy() {
    terraform destroy  \
        -var env="$ENV" \
        -var envVersion="$ENV_VERSION" \
        -var region="$AWS_REGION" \
        -var product="$PRODUCT" \
        -var createdBy="$CREATED_BY" \
        -var owner="$OWNER" \
        -auto-approve
}

init
    check_sucessful

destroy
    check_sucessful