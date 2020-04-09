# PostgreSQL demo

## About
Compose contain:
* [PostgreSQL](https://www.postgresql.org/) - Open Source RelDBMS [DB-Engines Ranking](https://db-engines.com/en/ranking)
* [Adminer](https://www.adminer.org/) - The full-featured database management tool written in single PHP-file

## Usage & Tuning
* Copy **.env** from **.env.example** and edit it.
* Initialization: Run Compose for first time
* (optional) configure Compose for the "running as local User"
* (optional) Configure postgresql.conf (also copy it to data-dir and restart Compose)
* Run Compose in daemon (background) mode
* (optional) Restore DB-dump

### Initialization
```bash
cd 11-psql
## Copy **.env** from **.env.example** and edit it.
cp .env.example .env

## First run - initialization
docker-compose up
### Wait until the message "database system is ready to accept connections"
###    then press [CTRL] + [C] to stop docker-compose 
```

### (optional) Running as local-user
```bash
## Find out your ID
id
uid=1000(rasla) gid=1000(rasla)
## Edit USER_UID and USER_GID
nano .env

## Change owner for Data
docker run -it --rm -v $(pwd):/mnt alpine chown -R 1000:1000 /mnt/psql

## Make 'docker-compose.override.yml'
cp docker-compose.override.example.yml docker-compose.override.yml
```

### (optional) Configure postgresql.conf
**"NEVER use PostgreSQL with default configuration !"** (C) "Postgres PRO Ltd" (and many other psql's DBA).  

After initialization, you should TUNE PostgreSQL (
[PGTune](https://pgtune.leopard.in.ua/#/) /
[Cybertec PostgreSQL Configurator](http://pgconfigurator.cybertec.at/) etc )
and copy the tuned **postgresql.conf** inside the docker-container.
```bash
cp -f psql/postgresql.conf.example psql/data/postgresql.conf
```

### Run Compose in daemon (background) mode
```bash
docker-compose up -d
docker-compose logs
```

## Usage
### Backup

```bash
## Backup Single DB
docker-compose exec -T psql pg_dump --clean --if-exists -U postgres -d postgres > dump.sql
docker-compose exec -T psql pg_dump --clean --if-exists -U postgres -d postgres | gzip > dump.sql.gz

## Backup ALL psql DBs (and Users with Passwords)
docker-compose exec -T psql \
  time pg_dumpall --clean --if-exists -U postgres  |  gzip > dump_all.sql.gz  
```

### Restore

```bash
## Restore Single DB
cat  dump.sql    | docker-compose exec -T psql psql -U postgres -d postgres
zcat dump.sql.gz | docker-compose exec -T psql psql -U postgres -d postgres

## Restore ALL psql DBs (and Users with Passwords)
zcat dump_all.sql.gz |  docker-compose exec -T psql \
  time psql -U postgres postgres

## Analyze all DBs (mandatory after Restore DB) 
docker-compose exec psql \
  time vacuumdb --all --analyze -U postgres
```

### Analyze
```bash
time vacuumdb --dbname=postgres --analyze -U postgres
time docker-compose exec -T psql vacuumdb --all --analyze -U postgres
time kubectl exec -i postgres-0 -- vacuumdb --all --analyze -U postgres
```

### Passwordless connection in console
You need to use **~/.pgpass** file for passwordless connection:
```text
###  Put content to the file ~/.pgpass !
#  Docker-compose .env.example
127.0.0.1:5432:postgres:postgres:password
#  Another server
psql-server2:5432:demo_db:demo_user:password2
#  PgBouncer
pgbouncer:6432:pgbouncer:admin:PaSsW0rD

### Usage
## Copy .pgpass
# cp .pgpass.example ~/.pgpass
# chmod 0600 ~/.pgpass
# psql -h 127.0.0.1 -U postgres postgres
# psql -h psql-server2 -U demo_user demo_db
# psql -h pgbouncer -p 6432 -U admin pgbouncer
```
### psql meta-commands
Full list of meta-commands you can see at [Postgres Pro Docs - app psql](https://postgrespro.ru/docs/postgresql/12/app-psql#APP-PSQL-META-COMMANDS)
* **\q** - quit
* **\di** - Index List
* **\dt** - Table List
* **\dv** - View List
* **\du** - User (Role) List
* **\password** - change password for Current User

## Connection pooler
PostgreSQL connections take up a lot of memory (about 10MB per connection) and start-up cost.

There is also a significant startup cost to establish a connection with TLS,
 hence web applications gain performance by using persistent connections.

By placing any pgSQL pooler (like, [PgBouncer](https://github.com/pgbouncer/pgbouncer)
 or [Yandex Odyssey](https://github.com/yandex/odyssey) ) between the web application
 and the real PostgreSQL database, you can significantly reduce memory and startup costs.

## See also
[Postgres Docker Hub](https://hub.docker.com/_/postgres/)  
[PgBouncer Docker Hub](https://hub.docker.com/r/edoburu/pgbouncer)  
[PgBouncer GitHub](https://github.com/pgbouncer/pgbouncer)  
[Yandex Odyssey GitHub](https://github.com/yandex/odyssey)
