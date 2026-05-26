#!/bin/bash
mkdir /etc/ansible/PC_INFO
wget raw.githubusercontent.com/19zammik86-source/DEMO/refs/heads/main/inventory2.yml
ansible-playbook /etc/ansible/inventory2.yml
cd /etc/ansible/PC_INFO
