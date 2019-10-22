# MySQL
This is "MySQL" docker-compose demo.  
Docker Hub page - [https://hub.docker.com/_/mysql/] , [https://hub.docker.com/_/percona/]

In this compose you can run MySQL:
1) With the necessary version: **5.6 / 5.7** / 8; **Percona** (recommended) or **Oracle** MySQL
1) With custom configs (located at `mysql/conf.d`)
1) As 'real' user from HostOS (there are NO problems with file-access)

Compose contains few useful shell-scripts:
* **mysql.sh** - connect to the docker-container and run mysql-client (as 'root') 
* **mysql-backup.sh** - backup User-defined DB (and sym-link as LAST dump) 
* **mysql-restore.sh** - restore User-defined DB from the LAST dump (with ANALYZE )
* **mysql-repair-and-optimize.sh** - Check, repair and optimize all DBs

## Prepare
1) Make local **docker-compose.override.yml**
```bash
## Make docker-compose.override.yaml
cp docker-compose.override.example.yml docker-compose.example.yml
```
**NOTE:** Without **docker-compose.override.yml** MySQL will start as 'root' user inside docker-container,
and all files/dirs will be created as 'root' user.

1) Make local **.env**
```bash
## Make .env
cp .env.example .env

## Change UID/GID and DB-credentials if you wish
nano .env
```

## Manage Docker-compose
```bash
# ENTER to the Docker-compose dir !
cd 2-docker-compose/10-mysql

## Start (as service)
docker-compose up -d

## Stop
docker-compose stop
or
docker-compose down
```

## Adminer
**Adminer** - is a full-featured database management tool written in PHP.
Conversely to phpMyAdmin, it consist of a single file ready to deploy to the target server.
Adminer is available for MySQL, MariaDB, PostgreSQL, SQLite, MS SQL, Oracle,
 Firebird, SimpleDB, Elasticsearch and MongoDB.

Open web-browser [http://localhost:80/] after Compose-Start (80 = **ADMINER_PORT**, by default in `.env` file).

Login:  
* Server: **mysql** - ('container_name' value in `docker-compose.yml`)
* Login and Password (see **MYSQL_** vars in `.env` file)
