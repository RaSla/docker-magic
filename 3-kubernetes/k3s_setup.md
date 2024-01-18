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
net.ipv4.tcp_rmem = 4096 8192 131072
net.ipv4.tcp_wmem = 4096 8192 131072
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
Configure OpenNTPd by `nano /etc/openntpd/ntpd.conf`
```editorconfig
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
## Ubuntu/Debian (apt)
$ curl -sfL https://raw.githubusercontent.com/RaSla/sh/main/install_kubectl.sh | sudo bash -s k_apt
## Any distr (by curl)
$ curl -sfL https://raw.githubusercontent.com/RaSla/sh/main/install_kubectl.sh | sudo bash -s k_curl v1.22.17

## rootless kubectl
$ wget https://storage.googleapis.com/kubernetes-release/release/v1.23.17/bin/linux/amd64/kubectl
$ chmod +x kubectl
$ mkdir -p ~/.local/bin
$ mv -f kubectl ~/.local/bin
$ echo 'if [ $(which kubectl | wc -l) = "1" ]; then source <(kubectl completion bash) ; fi' >> ~/.bashrc
```

#### 3.1 Install K3S on Master-node
Run few command on k3s-master (by **Root**):
```console
## Install or Upgrade K3S (WITHOUT Ingress-Traefik, for manual install Ingress-Nginx)
## -- by-version (v1.18.12+k3s1 / v1.19.4+k3s1)
# curl -sfL https://get.k3s.io | INSTALL_K3S_VERSION="v1.18.12+k3s1" sh -s - server --no-deploy traefik
## -- by-channel (v1.18 / v1.20 / stable / latest)  \  Multi-Master
# wget -O - https://get.k3s.io | INSTALL_K3S_CHANNEL="v1.20" sh -s - server --no-deploy traefik
## For install Multi-Master cluster, you need to append param:  --cluster-init

## Make bash-completion
# kubectl completion bash > /etc/bash_completion.d/kubectl
# crictl completion bash > /etc/bash_completion.d/crictl

## Copy kube-config
# mkdir -p ~/.kube
# cp /etc/rancher/k3s/k3s.yaml ~/.kube/config

## Check config by kubectl 
# kubectl get nodes
NAME      STATUS   ROLES    AGE   VERSION
au-master Ready    master   7m    v1.18.12+k3s1

## Modify default names:
# CLUSTER_NAME="alpha"
# sed -i "s|default|${CLUSTER_NAME}|g" ~/.kube/config

## (optional, for external usage) Modify Ipv4 in .kube/config
# ip addr | head | grep inet
    inet 127.0.0.1/8 scope host lo
    inet6 ::1/128 scope host 
    inet 192.168.110.20/24 brd 192.168.110.255 scope global dynamic noprefixroute enp1s0
# sed -i "s|127.0.0.1|192.168.110.20|g" ~/.kube/config

## (optional) Установка часов в UTC
# ln -sf /usr/share/zoneinfo/UTC /etc/localtime
```

#### 3.2 (optional) Install K3S on other Master-nodes
**WARNING!** For multi-master cluster, first Master-Node MUST BE installed with parameter **`--cluster-init`**
```console
## Get TOKEN and IP on Master
# cat /var/lib/rancher/k3s/server/node-token
K102cfb0e66a3932ddc6437440eb27b5f39d793fb9a5b42accb326b5abb70256b62::server:b6d49a0dd920ce4cc8c70e69ce4ac7d6
# ip addr | head | grep inet
    inet 127.0.0.1/8 scope host lo
    inet6 ::1/128 scope host 
    inet 192.168.110.21/24 brd 192.168.110.255 scope global dynamic noprefixroute enp1s0

## Add Master-Node
# curl -sfL https://get.k3s.io | \
 INSTALL_K3S_CHANNEL="v1.19" \
 K3S_TOKEN="K102cfb0e66a3932ddc6437440eb27b5f39d793fb9a5b42accb326b5abb70256b62::server:b6d49a0dd920ce4cc8c70e69ce4ac7d6" \
  sh -s - server --server https://192.168.110.21:6443  --no-deploy traefik

## Check Nodes
# kubectl get nodes
NAME             STATUS   ROLES         AGE   VERSION
delta-au         Ready    etcd,master   24m   v1.19.3+k3s3
i5-7600-worker   Ready    etcd,master   21m   v1.19.3+k3s3
ramarus-devops   Ready    etcd,master   12m   v1.19.3+k3s3
```

#### 3.3 (optional) Install K3S on Worker nodes
```console
## Get TOKEN and IP on Master
# cat /var/lib/rancher/k3s/server/node-token
K106486c8a458ff9b37776619efbb703a9808fbb1f3c370304bb878ab07a88efcd3::server:2f3c265fa034289c2b4aa30c6ed1f3e1
# ip addr | head | grep inet
    inet 127.0.0.1/8 scope host lo
    inet6 ::1/128 scope host 
    inet 192.168.110.20/24 brd 192.168.110.255 scope global dynamic noprefixroute enp1s0

## Add Worker-Node
# curl -sfL https://get.k3s.io | \
 K3S_TOKEN="K106486c8a458ff9b37776619efbb703a9808fbb1f3c370304bb878ab07a88efcd3::server:2f3c265fa034289c2b4aa30c6ed1f3e1" \
 K3S_URL=https://192.168.110.20:6443 \
  sh -

## Check on Master-Node
# kubectl get nodes
NAME      STATUS   ROLES    AGE   VERSION
au-master Ready    master   9m    v1.18.12+k3s1
worker-01 Ready    <none>   114s  v1.18.12+k3s1
```

### 4. K9S (optional)
[K9s](https://github.com/derailed/k9s) - Kubernetes CLI To Manage Your Clusters In Style!

[K8S Compatibility Matrix](https://github.com/derailed/k9s#k8s-compatibility-matrix) - K9S x K8S client

```console
## Install K9S - TUI Kubernetes CLI To Manage Your Clusters In Style!
## k8s client 1.21.3: wget https://github.com/derailed/k9s/releases/download/0.23.10/k9s_Linux_x86_64.tar.gz
## k8s client 1.25.3: wget https://github.com/derailed/k9s/releases/download/0.26.7/k9s_Linux_x86_64.tar.gz
## k8s client 1.26.1: >= v0.27.0
$ K9S_VERSION=0.31.6
$ wget https://github.com/derailed/k9s/releases/download/v${K9S_VERSION}/k9s_Linux_amd64.tar.gz
$ tar -xf k9s_Linux_*.tar.gz k9s
## ROOT
$ sudo mv k9s /usr/local/bin/
## ROOTLESS
$ mv k9s ~/.local/bin/
## Clean
$ rm k9s_Linux_*.tar.gz
```

### 5. HELM v3
```console
$ HELM_VERSION=v3.10.3
$ wget https://get.helm.sh/helm-${HELM_VERSION}-linux-amd64.tar.gz
$ tar -zxvf helm-${HELM_VERSION}-linux-amd64.tar.gz linux-amd64/helm
## ROOT
$ sudo mv linux-amd64/helm /usr/local/bin/helm
$ sudo helm completion bash > /etc/bash_completion.d/helm
## ROOTLESS
$ mkdir -p ~/.local/bin
$ mv linux-amd64/helm ~/.local/bin/
$ echo 'if [ $(which helm | wc -l) = "1" ]; then source <(helm completion bash) ; fi' >> ~/.bashrc
## Clean
$ rm -rf linux-amd64
$ rm helm-${HELM_VERSION}-linux-amd64.tar.gz

## Stable-repo
$ helm repo add stable https://charts.helm.sh/stable --force-update
$ helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
$ helm repo update
Hang tight while we grab the latest from your chart repositories...
...Successfully got an update from the "ingress-nginx" chart repository
...Successfully got an update from the "stable" chart repository
Update Complete. ⎈Happy Helming!⎈
```
See more - [helm.sh/docs/intro/quickstart/](https://helm.sh/docs/intro/quickstart/)

### 6. Ingress-Nginx 
```console
$ kubectl create namespace ingress-nginx

## (option A) - Install by HELM. https://github.com/kubernetes/ingress-nginx/
$ helm search repo nginx
NAME                            CHART VERSION   APP VERSION     DESCRIPTION                                       
ingress-nginx/ingress-nginx     3.10.1          0.41.2          Ingress controller for Kubernetes using NGINX a...
stable/nginx-ingress            1.41.3          v0.34.1         DEPRECATED! An nginx Ingress controller that us...
stable/nginx-ldapauth-proxy     0.1.6           1.13.5          DEPRECATED - nginx proxy with ldapauth            
stable/nginx-lego               0.3.1                           Chart for nginx-ingress-controller and kube-lego  
stable/gcloud-endpoints         0.1.2           1               DEPRECATED Develop, deploy, protect and monitor...

$ helm install ngx ingress-nginx/ingress-nginx -n ingress-nginx
```
ALTERNATIVE:
```console
$ kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v0.41.2/deploy/static/provider/baremetal/deploy.yaml
```

## 7. Automated upgrades
Full manual is located here - [rancher.com/docs/k3s/latest/en/upgrades/automated/](https://rancher.com/docs/k3s/latest/en/upgrades/automated/)
Install the system-upgrade-controller
```console
$ kubectl apply -f https://github.com/rancher/system-upgrade-controller/releases/download/v0.6.2/system-upgrade-controller.yaml
```
Configure plans - make **k3s_upgrade.yaml**
```yaml
# Server plan
apiVersion: upgrade.cattle.io/v1
kind: Plan
metadata:
  name: server-plan
  namespace: system-upgrade
spec:
  concurrency: 1
  cordon: true
  nodeSelector:
    matchExpressions:
    - key: node-role.kubernetes.io/master
      operator: In
      values:
      - "true"
  serviceAccountName: system-upgrade
  upgrade:
    image: rancher/k3s-upgrade
  # Upgrade type: version or channel
  #version: v1.18.13+k3s1
  channel: https://update.k3s.io/v1-release/channels/v1.18  # v1.18 / v1.19 / stable / latest

---
# Agent plan
apiVersion: upgrade.cattle.io/v1
kind: Plan
metadata:
  name: agent-plan
  namespace: system-upgrade
spec:
  concurrency: 1
  cordon: true
  nodeSelector:
    matchExpressions:
    - key: node-role.kubernetes.io/master
      operator: DoesNotExist
  prepare:
    args:
    - prepare
    - server-plan
    image: rancher/k3s-upgrade  # :v1.18.13+k3s1
  serviceAccountName: system-upgrade
  upgrade:
    image: rancher/k3s-upgrade
  # Upgrade type: version or channel
  #version: v1.18.12+k3s1
  channel: https://update.k3s.io/v1-release/channels/v1.18  # v1.18 / v1.19 / stable / latest
```
Apply Plan for K3S-Cluster
```console
$ kubectl apply -f k3s_upgrade.yaml
plan.upgrade.cattle.io/server-plan created
plan.upgrade.cattle.io/agent-plan created

## Check
$ kubectl -n system-upgrade get plans -o yaml
$ kubectl -n system-upgrade get jobs -o yaml
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
