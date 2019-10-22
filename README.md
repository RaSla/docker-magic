# Docker Magic
This repo contains Docker's usage examples.  

I divided **Docker-Magic** into 3 levels:
1. **Docker** - use of **single** docker container, including topics:
    * Get docker-image;
    * Make docker-image (with Dockerfile);
    * Run docker-image;
    * Run docker-image with custom params (port-mapping, disk-volumes, env-vars);
1. **Docker-compose** - use of **compositions** of Docker-containers (on a single server), including topics:
    * Combine few docker-images into the Application
    * Configure Application (for multi envs/users)
    * Mapping files/dirs between docker-containers and Host-OS
    * Mapping TCP/UDP ports between docker-containers and Host-OS
1. **Kubernetes** - use of **orchestrator** (on multi-server cluster)

## Requirements
* Install **[Docker-CE](https://docs.docker.com/install/)**  
or deb-package **docker.io** (Ubuntu 16.04+, Debian 10+): `sudo apt install docker.io`

* (optional, but recommended) [Post-installation steps for Linux](https://docs.docker.com/install/linux/linux-postinstall/):
    * Manage Docker as a non-root user
    * Configure Docker to start on boot
    * Create user-defined network: `docker network create app`
    
* To install **[Docker-Compose](https://docs.docker.com/compose/install/)** make a few steps (on Linux):
    ```bash
    sudo apt install python3-pip;
    sudo pip3 install docker-compose==1.24.0
    ```

## YAML-linter
**IMPORTANT**
Before commit changes - you MUST check code (& fix errors, if possible) by linter:
```bash
## (once) Install Linters
sudo pip3 install yamllint==1.16.0

## PRE-commit check
yamllint .
```
