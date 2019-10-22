# Docker-compose

**Docker-compose** - make a **composition** of Docker-containers (on one server, usually).
* Combine few docker-images into the Application
* Configure Application (for multi envs/users)
* Setting ENV-vars from `.env` file inside docker-compose dir
* Mapping files/dirs between docker-containers and Host-OS
* Mapping TCP/UDP ports between docker-containers and Host-OS
* Can limit resources to docker-containers
* Can scale services horizontally

## The right way to use

1) **Make `docker-compose.yml` self-sufficient** - all required services MUST BE listed in `docker-compose.yml` !

    `docker-compose.yml` MUST BE workable without `docker-compose.override.yml`.
    `docker-compose.yml` MAY necessarily require variables from a `.env` file

    Sometimes, users put description of some service(s) in `docker-compose.override.yml` (it's good when such a service is optional),
    BUT if Application CAN'T work without this service(s) - you are wrong !
    
1) **Make `docker-compose.override.yml` as Application-optional extension** - options,
 that extend or customize the application for specific cases.

    Like, `docker-compose.yml` contains MySQL-service definition
    ```yaml
      mysql:
        container_name: mysql
        image: percona:5.6
        environment:
          - "MYSQL_ROOT_PASSWORD=${MYSQL_ROOT_PASSWORD}"
        ports:
          - "3306:3306"
        volumes:
          - ./mysql/conf.d:/etc/my.cnf.d
          - ./mysql/data:/var/lib/mysql
    ```
    
    And `docker-compose.override.yml` contains "Run as specific user" option:
    ```yaml
      ## Run MySQL as App-User (no problems with Read/Write files/dirs)
      mysql:
        tmpfs:
          - "/var/run/mysqld:uid=${USER_UID}"
        user: "${USER_UID}:${USER_GID}"
    ```

1) **Make all private/specific config-vars in .env-file** - all env/user-specific vars MUST BE stored in `.env` file !

    If you need to use some PASSWORDS and other secret vars - put it in `.env` file, like:
    ```dotenv
    MYSQL_ROOT_PASSWORD=password
    MYSQL_DATABASE=demo_db
    MYSQL_PASSWORD=pass
    MYSQL_USER=demo
    
    #admin@db-server2:~/docker/mysql$ id
    #uid=1000(admin) gid=1000(admin)
    USER_UID=1000
    USER_GID=1000
    ```

1) **Make the example of private/specific files** - put `.env.example` and `docker-compose.override.example.yml` in git-repo.

    You MUST put **example** file(s) in git-repo, that necessary for Application.
    
    Application MUST BE workable, if you just git-clone Project and copy example-files as current-files.

1) **Mask env/user-specific files in .gitignore file** - do not put private data and current-configs in git-repo!
    ```gitignore
    # Current-config
    .env
    docker-compose.override.yml

    ## Data
    mysql/data/*
    ## Logs
    mysql/log/*
    
    ## Backups and Local
    *~
    *.bak
    *.local
    ```

## Manage Docker-compose
**NOTE**: Docker-compose work **in CURRENT dir** !  
You need to change dir for work with specific Compose
```bash
# ENTER to the Compose dir !
cd 2-docker-compose/10-mysql

## HELP
docker-compose --help

## Start (interactive mode, for debug)
docker-compose up

  Press [CTRL]+[C] to stop execution

## Start (as service)
docker-compose up -d

## List all running containers
docker-compose ps
docker ps

## Execute command in running container
docker-compose exec mysql  mysql --version

## Stop
docker-compose stop

## Down (stop and clean temporary Containers,Volumes)
docker-compose down
```