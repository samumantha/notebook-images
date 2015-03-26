#!/bin/bash

set -e
set -x

sudo aptitude update
sudo aptitude install -y git build-essential python-dev python-setuptools
sudo easy_install pip
sudo pip install ansible

if ! id | grep "(docker)" > /dev/null; then
  if ! getent group docker > /dev/null; then
    sudo groupadd -r docker
  fi
  sudo usermod -a -G docker $USER
  echo ""
  echo "Log out and log in again to make docker group effective for $USER, then run me again"
  echo ""
  exit 0
fi

PB_BRANCH=feature/multiple_containers#58
PB_REPO=https://github.com/CSC-IT-Center-for-Science/pouta-blueprints

set -e
set -x

pb_temp=$(mktemp -d)

git clone --branch $PB_BRANCH $PB_REPO $pb_temp/git

(
echo "[docker_host]"
echo "localhost ansible_connection=local"
) > $pb_temp/pb_ansible_inventory

export PYTHONUNBUFFERED=1
ansible-playbook -i $pb_temp/pb_ansible_inventory $pb_temp/git/ansible/prepare_vm.yml

cd $pb_temp/git && scripts/deploy_local_docker_containers.bash

rm -rf $pb_temp

