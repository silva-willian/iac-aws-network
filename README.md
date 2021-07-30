# Introdução 
Projeto criado para criação de VPC, subnets e IGW na AWS

# Setup do ambiente
Instale os seguintes itens em sua maquina:
1.	Instalar a versão v0.14.6 do terraform
2.	Instalar o Docker e docker compose

# Execução com Docker
1. Abra o prompt de comando
2. Acesse a pasta raiz do projeto
3. Rode o comando buildar o container de teste: docker build -t test -f devops/iac/test/Dockerfile .
4. Rode o comando para validar o terraform: docker run \
	-e AWS_ACCESS_KEY_ID="your_key" \
	-e AWS_SECRET_ACCESS_KEY="your_secret" \
	-e AWS_REGION="your_region" \
	-e REMOTE_STATE_BUCKET="your_base_name_remote_state_bucket" \
	-e REMOTE_STATE_FILE="your_file.tfstate" \
	-e REMOTE_STATE_AWS_REGION="your_region" \
	-e ENV="your_env" \
	-e ENV_VERSION="your_env_version" \
	-e PRODUCT="your_produt" \
	-e CREATED_BY="devops-tools" \
	-e OWNER="your_owner" \
	test

5. Rode o comando buildar o container de criação da VPC: docker build -t deploy -f devops/iac/deploy/Dockerfile .
6. Rode o comando para validar o terraform: docker run \
	-e AWS_ACCESS_KEY_ID="your_key" \
	-e AWS_SECRET_ACCESS_KEY="your_secret" \
	-e AWS_REGION="your_region" \
	-e REMOTE_STATE_BUCKET="your_base_name_remote_state_bucket" \
	-e REMOTE_STATE_FILE="your_file.tfstate" \
	-e REMOTE_STATE_AWS_REGION="your_region" \
	-e ENV="your_env" \
	-e ENV_VERSION="your_env_version" \
	-e PRODUCT="your_produt" \
	-e CREATED_BY="devops-tools" \
	-e OWNER="your_owner" \
	deploy

7. Rode o comando buildar o container de destruição da VPC: docker build -t destroy -f devops/iac/destroy/Dockerfile .
8. Rode o comando para validar o terraform: docker run \
	-e AWS_ACCESS_KEY_ID="your_key" \
	-e AWS_SECRET_ACCESS_KEY="your_secret" \
	-e AWS_REGION="your_region" \
	-e REMOTE_STATE_BUCKET="your_base_name_remote_state_bucket" \
	-e REMOTE_STATE_FILE="your_file.tfstate" \
	-e REMOTE_STATE_AWS_REGION="your_region" \
	-e ENV="your_env" \
	-e ENV_VERSION="your_env_version" \
	-e PRODUCT="your_produt" \
	-e CREATED_BY="devops-tools" \
	-e OWNER="your_owner" \
	destroy

# Contribuidores
- Willian da Silva