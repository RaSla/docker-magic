#!/bin/bash

K8S_VERSION="1.19.3-00"

set -e

# Check UserID
if [ $UID != "0" ]; then
    echo "ERROR: You MUST run this script with ROOT-privileges:"
    echo "sudo $0"
    exit 1
fi

echo "*** Install kubectl=${K8S_VERSION} ***"
echo "* Get APT-KEY"
## [Debian] apt install gnupg2
#curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add
wget -O - https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add

## [Debian] apt install software-properties-common
echo "* Add APT-REPO 'apt.kubernetes.io'"
apt-add-repository "deb http://apt.kubernetes.io/ kubernetes-xenial main"
echo "* APT UPDATE"
apt update

echo "* Install kubectl=${K8S_VERSION}"
apt install kubectl=${K8S_VERSION}
apt-mark hold kubectl

echo "* Make BASH-completion: /etc/bash_completion.d/kubectl"
whereis kubectl
mkdir -p /etc/bash_completion.d
kubectl completion bash > /etc/bash_completion.d/kubectl

echo "*** Done ***"
