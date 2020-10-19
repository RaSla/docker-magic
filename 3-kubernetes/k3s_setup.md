# K3S - 5 less than k8s
[K3S](https://k3s.io/) - Lightweight certified Kubernetes distribution built for IoT & Edge computing.

Easy to install, half the memory, all in a binary less than 50mb.

K3S is great for:
* Edge
* IoT
* CI
* ARM
* Situations where a PhD in k8s clusterology is infeasible

## Install

### 1. Generic OS-setup
* Turn off "Automatic Linux-kernel upgrade"
* Raise the network limits:
```text
### nano /etc/sysctl.d/95-net_fast_stack.conf
# https://www.slideshare.net/brendangregg/how-netflix-tunes-ec2-instances-for-performance

## Network connections
#  date +'%Y-%m-%d %H:%M:%S %z';  netstat -s | egrep 'backlog|queue|retrans|fail';  uptime
net.core.somaxconn = 10000
net.core.netdev_max_backlog = 5000
net.ipv4.tcp_max_syn_backlog = 8000
# https://github.com/ton31337/tools/wiki/Is-net.ipv4.tcp_abort_on_overflow-good-or-not%3F
net.ipv4.tcp_abort_on_overflow = 1
# добавит скорости для SPDY/HTTP2 и других keep-alive соединений.
net.ipv4.tcp_slow_start_after_idle = 0
# включает временные метки протокола TCP, которые позволяют управлять работой протокола в условиях высоких нагрузок
net.ipv4.tcp_timestamps = 1
# повторное использование TIME-WAIT сокетов в случаях, если протокол считает это безопасным.
net.ipv4.tcp_tw_reuse = 1
# system capability for making outbound connections per second
net.ipv4.ip_local_port_range = 10240 65535
net.ipv4.tcp_fin_timeout = 30

# AWS T3/C5/M5 instance-types have good NIC
net.core.rmem_max = 16777216
net.core.wmem_max = 16777216
# Увеличиваем лимиты автотюнинга (min, default, max bytes)
net.ipv4.tcp_rmem = 4096 131072 16777216
net.ipv4.tcp_wmem = 4096 174760 16777216
net.ipv4.netfilter.ip_conntrack_max = 16777216

## sysctl -p --system
```
and
```text
### nano /etc/sysctl.d/95-net_anti_ddos.conf

### ORIGINAL: /etc/sysctl.d/10-network-security.conf (u1804)
# Turn on Source Address Verification in all interfaces to
# prevent some spoofing attacks.
net.ipv4.conf.default.rp_filter=1
net.ipv4.conf.all.rp_filter = 1

# Turn on SYN-flood protections.  Starting with 2.6.26, there is no loss
# of TCP functionality/features under normal conditions.  When flood
# protections kick in under high unanswered-SYN load, the system
# should remain more stable, with a trade off of some loss of TCP
# functionality/features (e.g. TCP Window scaling).
net.ipv4.tcp_syncookies=1

###  ADDITIONAL  ###
# запрет маршрутизации от источников
#net.ipv4.conf.all.accept_source_route = 0

# игнорируем ошибочные ICMP запросы
net.ipv4.icmp_ignore_bogus_error_responses = 1

# защита от  TIME_WAIT атак.
net.ipv4.tcp_rfc1337 = 1

## sysctl -p --system
```

### 2. Setup NTP
HW-clocks MUST BE synchronized on all Nodes.

Setup OpenNTPd (or LinuxPTP)
```console
## Install OpenNTPd
$ apt install openntpd
```
Configure OpenNTPd
```console
$ nano /etc/openntpd/ntpd.conf
# Addresses to listen on (ntpd does not listen by default)
#listen on *
#listen on 127.0.0.1

# sync to a single server
#server ntp.server.local

# use a random selection of NTP Pool Time Servers
# see http://support.ntp.org/bin/view/Servers/NTPPoolServers
#servers pool.ntp.org
servers 2.debian.pool.ntp.org
#servers 3.debian.pool.ntp.org

# use a specific local timedelta sensor (radio clock, etc)
#sensor nmea0
```
Restart OpenNTPd
```console
$ service openntpd restart
```

### 3. K3S
**Recommended** to install kubectl before install K3S.
```console
## Ubuntu/Debian
$ curl -sfL https://raw.githubusercontent.com/RaSla/docker-magic/develop/3-kubernetes/install_kubectl_by_apt.sh | sh -s
```

Run few command on k3s-master (by **Root**):
```console
## Install or Upgrade K3S (WITHOUT Ingress-Traefik, for manual install Ingress-Nginx)
$ curl -sfL https://get.k3s.io | INSTALL_K3S_VERSION="v1.18.8+k3s1" sh -s - server --no-deploy traefik
## (or) Install by-channel (stable, latest)
$ curl -sfL https://get.k3s.io | INSTALL_K3S_CHANNEL="latest" sh -s - server --no-deploy traefik
## Check
$ kubectl get nodes
NAME      STATUS   ROLES    AGE   VERSION
cert-au   Ready    master   27m   v1.18.8+k3s1

## Make bash-completeon
$ kubectl completion bash > /etc/bash_completion.d/kubectl
$ crictl completion bash > /etc/bash_completion.d/crictl

## Copy kube-config
$ mkdir -p ~/.kube
$ cp /etc/rancher/k3s/k3s.yaml ~/.kube/config

## Modify default names:
CLUSTER_NAME="alpha"
sed -i "s|default|${CLUSTER_NAME}|g" ~/.kube/config

## (optional, for external usage) Modify Ipv4 in .kube/config
ip addr | head | grep inet
    inet 127.0.0.1/8 scope host lo
    inet6 ::1/128 scope host 
    inet 192.168.110.20/24 brd 192.168.110.255 scope global dynamic noprefixroute enp1s0
sed -i "s|127.0.0.1|192.168.110.20|g" ~/.kube/config

## (optional) Установка часов в UTC
ln -sf /usr/share/zoneinfo/UTC /etc/localtime
```

### 4. K9S (optional)
[K9s](https://github.com/derailed/k9s) - Kubernetes CLI To Manage Your Clusters In Style!
```bash
## Install K9S - console tools for kubernetes
K9S_VERSION=0.13.8
wget https://github.com/derailed/k9s/releases/download/v${K9S_VERSION}/k9s_${K9S_VERSION}_Linux_x86_64.tar.gz
tar -xf k9s_${K9S_VERSION}_Linux_x86_64.tar.gz k9s
sudo mv k9s /usr/local/bin/
rm k9s_${K9S_VERSION}_Linux_x86_64.tar.gz
```

### 5. HELM v3
```bash
HELM_VERSION=v3.3.4
wget https://get.helm.sh/helm-${HELM_VERSION}-linux-amd64.tar.gz
tar -zxvf helm-${HELM_VERSION}-linux-amd64.tar.gz linux-amd64/helm
sudo mv linux-amd64/helm /usr/local/bin/helm
rm -rf linux-amd64
rm helm-${HELM_VERSION}-linux-amd64.tar.gz

## BASH completion
sudo helm completion bash > /etc/bash_completion.d/helm

## Stable-repo
helm repo add stable https://kubernetes-charts.storage.googleapis.com/
helm repo update
```

### 6. Ingress-Nginx 
```console
$ kubectl create namespace ingress-nginx

## (option A) - Install by HELM. https://github.com/kubernetes/ingress-nginx/
$ helm install all stable/nginx-ingress -n ingress-nginx
```
ALTERNATIVE:
```console
$ kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v0.35.0/deploy/static/provider/baremetal/deploy.yaml
```

## Uninstall
To uninstall K3s from a server node, run:
```console
$ /usr/local/bin/k3s-uninstall.sh
```
To uninstall K3s from an agent node, run:
```console
$ /usr/local/bin/k3s-agent-uninstall.sh
```

To purge all files, run:
```console
## Delete all files
$ rm -rf /var/lib/rancher/
$ rm -rf /var/log/containers/
$ rm -rf /var/log/pods
$ journalctl --vacuum-time=2d

## Delete all configs
$ rm -rf /etc/rancher
$ rm -rf ~/.kube
```
