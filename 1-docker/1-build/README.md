# Docker 1

## About
Simple example of building Docker-image with Dockerfile. 

## Requirement 
* Install **[Docker-CE](https://docs.docker.com/install/)**  
or deb-package **docker.io** (Ubuntu 16.04+, Debian 10+): `sudo apt install docker.io`

## Build Docker-image
```bash
docker build -t docker-magic:1 .
```

## Run Docker-container
```bash
docker run -it docker-magic:1

docker run -it --rm docker-magic:1 php --version

docker run -it --rm docker-magic:1 sh
```

## Cleanup
```bash
docker container prune -f ;  docker image prune -f ; docker volume prune -f
```