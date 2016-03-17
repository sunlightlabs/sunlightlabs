#!/usr/bin/env bash

# tease out path to provisioning source from ansible cfg file
SOURCE_PATH="$(cat ansible/ansible.cfg | grep source_path | awk -F'=' '{print $2}' | tr -d ' ')"

cd ansible
ansible-galaxy install -r "$SOURCE_PATH/install_roles.yml"
ansible-playbook provision.yml --extra-vars "source_path=$SOURCE_PATH"
cd -