#!/bin/bash

sudo apt-get update
sudo apt-get upgrade -y

#Install python
sudo apt-get install python3 -y
sudo apt-get install python3-pip -y

#Install sshpass
sudo apt-get install sshpass -y

# Install kubectl
sudo apt-get install -y apt-transport-https ca-certificates curl
sudo curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update
sudo apt-get install kubectl -y
sudo pip3 install -r requirements.txt

