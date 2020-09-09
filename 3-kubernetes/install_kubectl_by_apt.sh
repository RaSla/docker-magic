#!/bin/bash

K8S_VERSION="1.18.8-00"

# Check UserID
if [ $UID != "0" ]; then
    echo "ERROR: You MUST run this script with ROOT-privileges:"
    echo "sudo $0"
    exit 1
fi

echo "*** Install kubectl=${K8S_VERSION} ***"
echo "* Get APT-KEY"
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add
echo "* Add APT-REPO 'apt.kubernetes.io'"
apt-add-repository "deb http://apt.kubernetes.io/ kubernetes-xenial main"
#echo "* APT UPDATE"
#sudo apt update

echo "* Install kubectl=${K8S_VERSION}"
apt install kubectl=${K8S_VERSION}

echo "* Make BASH-completion: /etc/bash_completion.d/kubectl"
whereis kubectl
kubectl completion bash > /etc/bash_completion.d/kubectl

echo "*** Done ***"
