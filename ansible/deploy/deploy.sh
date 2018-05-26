#!/bin/bash
echo "Creating virtualenv"
virtualenv venv-gitlab
source venv-gitlab/bin/activate

echo "Installing dependencies"
pip install -r requirements.txt &>/dev/null

echo "Deploy ...."
#ansible-playbook playbook_config.yml -e deploy_env=$DEPLOY_ENV -e despliegue_pais=$2 $3
