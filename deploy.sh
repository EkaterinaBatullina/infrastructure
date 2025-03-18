#!/bin/sh
set -e

which ssh-agent || (sudo apt-get update && sudo apt-get install -y openssh-client)

eval $(ssh-agent -s)

echo "$SSH_PRIVATE_KEY" | tr -d '\r' | ssh-add - > /dev/null

mkdir -p ~/.ssh
chmod 700 ~/.ssh
cp config ~/.ssh

ssh -o "StrictHostKeyChecking=no" $SSH

ssh "$SSH" "sudo docker login -u gitlab-ci-token -p $CI_JOB_TOKEN $CI_REGISTRY"

ssh "$SSH" "sudo rm -r batullina-agona-2024/ || echo 0"

ssh "$SSH" "git clone git@gitlab.com:batullina-agona-2024.git"

ssh "$SSH" "cd batullina-agona-2024/Agona-05 && git checkout $BRANCH"

ssh "$SSH" "sudo docker pull registry.gitlab.com/batullina-agona-2024:$TAG"

ssh "$SSH" "sudo docker-compose -p $BRANCH -f ~/batullina-agona-2024/Agona-05/docker/docker-compose.$TAG.yml down"

ssh "$SSH" "sudo docker-compose -p $BRANCH -f ~/batullina-agona-2024/Agona-05/docker/docker-compose.$TAG.yml up --no-build -d"

ssh "$SSH" "sudo rm -r batullina-agona-2024/"

ssh "$SSH" "docker logout $CI_REGISTRY"
