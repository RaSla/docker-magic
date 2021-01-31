# Test-app
The 'Demo-App' with few services and **SOME ERRORS** !!! ;-)  

If you will **FIX all errors** in this docker-compose,
then you will get fully working application !  **TEST yourself** !

Demo-app contains:
* **Nginx** - frontend web-server & API-router;
* **PHP** app/micro-service ;
* **Python** app/micro-service;
* **Redis** for In-memory cache (used by both of PHP/Python services);
* **MySQL** - popular RDBMs;
* dockercloud/**haproxy** - load balancer for dynamic scaling;
* some **bash-scripts** with useful docker-commands.

## Prerequisites
Docker-CE and Docker-Compose is installed

## Usage
Start, fail, try to fix and again...

As much as required, until you will fix all of them.

### Start
* ```~/demo-app$ docker-compose up``` - Run if foreground
* ```~/demo-app$ docker-compose up -d``` - Run if background
* ```~/demo-app$ docker-compose up -d redis``` - Run only 1 service from docker-compose

### Stop
* ```~/demo-app$ docker-compose stop``` - Stop
* ```~/demo-app$ docker-compose down``` - Stop and Clean

### Scaling
* ```~/demo-app$ docker-compose scale py3=4``` - scale ``py3``-service up or down to 4 instances

## Adminer
Connect to MySQL params:
* host: **mysql** (see service_name in `docker-compose.yml`)
* db / user / password - see in .env-file