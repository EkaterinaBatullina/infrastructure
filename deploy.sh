#!/bin/sh
set -e

which ssh-agent || (sudo apt-get update && sudo apt-get install -y openssh-client)

eval $(ssh-agent -s)
echo "$SSH_PRIVATE_KEY" | tr -d '\r' | ssh-add - > /dev/null
mkdir -p ~/.ssh
chmod 700 ~/.ssh
cp config ~/.ssh

#ssh-keyscan gitlab.com >> ~/.ssh/known_hosts

echo "Список загруженных SSH-ключей:"
ssh-add -L

echo "Подключение с логированием:"
ssh -T git@gitlab.com

ssh -o "StrictHostKeyChecking=no" $SSH

ssh "$SSH" "sudo rm -r ~/infrastructure2/ || echo 0"

ssh "$SSH" "GIT_SSH_COMMAND='ssh -i /home/eka_rina16/.ssh/id_rsa_vm_new' git clone git@gitlab.com:EkaterinaBatullina/infrastructure2.git"

ssh "$SSH" "cd ~/infrastructure2/ && git checkout $BRANCH"

ssh "$SSH" "sudo docker login -u gitlab-ci-token -p glpat-8QYBRfe7gSiqMesP9fee $CI_REGISTRY"

ssh "$SSH" "sudo docker pull registry.gitlab.com/ekaterinabatullina/infrastructure2/user-service/user-service-impl:$TAG"

ssh "$SSH" "sudo docker-compose -p $BRANCH -f ~/infrastructure2/docker-compose.$TAG.yml down"

ssh "$SSH" "sudo docker-compose -p $BRANCH -f ~/infrastructure2/docker-compose.$TAG.yml up --no-build -d"

ssh "$SSH" "sudo rm -r ~/infrastructure2/"

ssh "$SSH" "docker logout $CI_REGISTRY"