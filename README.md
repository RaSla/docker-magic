# Docker Magic
This repo contains Docker's usage examples.  

I divided **Docker-Magic** into 3 levels:
1. **Docker** - use of **single** docker container, including topics:
    * Get docker-image;
    * Make docker-image (with Dockerfile);
    * Run docker-container;
    * Run docker-container with custom params (env-vars, port-mapping, disk-volumes, as specific user);
1. **Docker-compose** - use of **compositions** of Docker-containers (on a single server), including topics:
    * Combine few docker-images into the Application
    * Configure Application (for multi envs/users)
    * Mapping files/dirs between docker-containers and Host-OS
    * Mapping TCP/UDP ports between docker-containers and Host-OS
    * Can limit resources to docker-containers
1. **Kubernetes** - use of **orchestrator** (in multi-server cluster)

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

# Production and Development advices
* Use **[Alpine Linux](https://alpinelinux.org/)** docker-images as base, if it possible
(`postgres:12-alpine` instead of `postgres:12`, for example)
* Update your docker-images ASAP, when the base-image is updated
* Use **.dockerignore** file - prevent unnecessary files from appearing in the docker-image

## Development environment
1) The developer's docker-image **may exclude the source code** for interpreted languages (like PHP, Python etc),
if it is sufficient to build the Runtime docker-image and mount the Sources as a Volume to the docker-container.

1) Developer's docker-images **may contain** some **useful tools**, such as XDebug (for PHP), etc.
 that are not needed in the production docker-images.

## Production environment
1) The Production docker-image **MUST contain all** Application files **inside** docker-image !  
The only exception is - connecting to the production docker-container external persistent storage
 for the Logs and Data (like: MySQL data-dir, shared assets-folder for Samba/NFS, etc).

1) The Production docker-image **MUST NOT contain** any **unnecessary** tools and files !
    * Less files - less docker-image size;
    * Less binary - less potential vulnerabilities
