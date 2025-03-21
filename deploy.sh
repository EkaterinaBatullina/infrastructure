#!/bin/sh
set -e

which ssh-agent || (sudo apt-get update && sudo apt-get install -y openssh-client)

eval $(ssh-agent -s)

# Добавление приватного ключа в ssh-agent
if [ -n "$SSH_PRIVATE_KEY" ]; then
    echo "$SSH_PRIVATE_KEY" | tr -d '\r' | ssh-add - > /dev/null
else
    echo "Ошибка: SSH_PRIVATE_KEY не найден."
    exit 1
fi

# Создание директории для SSH-ключей и конфигурации
mkdir -p ~/.ssh
chmod 700 ~/.ssh

# Копирование конфигурации SSH (если конфиг существует)
if [ -f config ]; then
    cp config ~/.ssh
else
    echo "Ошибка: конфигурационный файл SSH не найден."
    exit 1
fi
ssh-keyscan gitlab.com >> ~/.ssh/known_hosts

echo "Список загруженных SSH-ключей:"
ssh-add -L

echo "Подключение:"
ssh -T git@gitlab.com

echo "Подключение с подробным логированием:"
ssh -vvv -T git@gitlab.com

ssh -o "StrictHostKeyChecking=no" $SSH

#ssh "$SSH" "sudo docker login -u gitlab-ci-token -p $CI_JOB_TOKEN $CI_REGISTRY"

ssh "$SSH" "sudo rm -r batullina-agona-2024/ || echo 0"

#ssh "$SSH" "ssh-keyscan gitlab.com >> /root/.ssh/known_hosts"

#ssh "$SSH" "mkdir -p ~/.ssh && ssh-keyscan gitlab.com >> ~/.ssh/known_hosts"

ssh "$SSH" "git clone -b develop git@gitlab.com:EkaterinaBatullina/batullina-agona-2024.git"

#ssh "$SSH" "git clone -b develop git@gitlab.com:EkaterinaBatullina/batullina-agona-2024.git"

ssh "$SSH" "cd batullina-agona-2024/Agona-05 && git checkout $BRANCH"

ssh "$SSH" "mkdir -p ~/batullina-agona-2024/Agona-05/target"

scp "$SSH:~/batullina-agona-2024/Agona-05/target/Agona-05-1.0-SNAPSHOT.jar" .

ssh "$SSH" "sudo docker pull registry.gitlab.com/batullina-agona-2024:$TAG"

ssh "$SSH" "sudo docker-compose -p $BRANCH -f ~/batullina-agona-2024/Agona-05/docker/docker-compose.$TAG.yml down"

ssh "$SSH" "sudo docker-compose -p $BRANCH -f ~/batullina-agona-2024/Agona-05/docker/docker-compose.$TAG.yml up --no-build -d"

ssh "$SSH" "sudo rm -r batullina-agona-2024/"

ssh "$SSH" "docker logout $CI_REGISTRY"
