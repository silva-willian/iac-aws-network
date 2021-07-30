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

plan() {

    terraform plan  \
        -var env="$ENV" \
        -var envVersion="$ENV_VERSION" \
        -var region="$AWS_REGION" \
        -var product="$PRODUCT" \
        -var createdBy="$CREATED_BY" \
        -var owner="$OWNER" \
        -out="plan.tfout"
}

apply() {
    terraform apply plan.tfout
        check_sucessful

    rm -rf plan.tfout
        check_sucessful
}

init
    check_sucessful

plan
    check_sucessful

apply
    check_sucessful