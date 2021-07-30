FROM ubuntu:20.10

RUN apt-get update && \
    apt-get install -y wget && \
    apt-get install -y unzip && \
    wget https://releases.hashicorp.com/terraform/0.14.3/terraform_0.14.3_linux_amd64.zip && \
    unzip ./terraform_0.14.3_linux_amd64.zip -d /usr/local/bin/

WORKDIR /app

COPY . .

CMD chmod +x devops/iac/destroy/destroy.sh && \
    ./devops/iac/destroy/destroy.sh