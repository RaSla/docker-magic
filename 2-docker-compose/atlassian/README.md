# About
Docker-compose for Jira/Confluence with MySQL/PostgreSQL

#  Install
## 0. Requirements
* Install official [Docker-CE](https://docs.docker.com/install/linux/docker-ce/ubuntu/#install-docker-ce)  
  (or docker.io \[ubuntu 16.04+, debian 10+\]: `sudo apt install docker.io` )
* Install Docker-Compose
```bash
sudo apt install python3-pip;
sudo pip3 install docker-compose==1.25.0
```

## 1. Environment
Configure `.env` file.  
**NOTE**: Don't forget to setup correct UID and GID vars !

## 2. Setup DataBase
You can use few DB-engines for Atlassian products.  
Atlassian recommends using PostgreSQL (10), if you have no preference.  
Setup **only 1** of them. Comment "another DB" block in `docker-compose.yml`.  

### 2a. PostgreSQL
Copy `docker-compose.override.init.yml`. And start PostgreSQL:
For using PostgreSQL "as user UID" need to do hack:  
```bash
## Clean psql-data
docker run -it --rm -v $(pwd):/mnt alpine rm -rf /mnt/psql/data

## Copy 'init' override.yml
cp -f docker-compose.override.init.yml docker-compose.override.yml
## Init DB
docker-compose up atl-psql
### Wait until the message "database system is ready to accept connections"
###    then press [CTRL] + [C] to stop docker-compose
```

* Change owner and copy tuned config:
```bash
## Change owner for Data
docker run -it --rm -v ${PWD}:/mnt alpine chown -R $UID /mnt/psql/data

## Make 'docker-compose.override.yml'
cp -f docker-compose.override.user.yml docker-compose.override.yml

## Copy tuned config
cp -f psql/postgresql.conf.example psql/data/postgresql.conf
```

* Tune PostgreSQL  
**NOTE**: **ALWAYS** tune PostgreSQL before using !!!  
You could use "psql-configurator", like [PgTune](https://pgtune.leopard.in.ua/#/)
or [Cybertec PostgreSQL Configurator](http://pgconfigurator.cybertec.at/) to make `postgresql.conf`.  
Or use this simple config, at least for `psql/data/postgresql.conf`:
```ini
##  https://pgtune.leopard.in.ua/#/
# DB Version: 10
# OS Type: linux
# DB Type: oltp
# Total Memory (RAM): 1 GB
# CPUs num: 2
# Connections num: 70
# Data Storage: ssd

listen_addresses = '*'
#port = 5432
max_connections = 70
superuser_reserved_connections = 3

dynamic_shared_memory_type = posix	# the default is the first option
shared_buffers = 450MB		    # min 128kB
work_mem = 16MB				    # min 64kB
maintenance_work_mem = 64MB	    # min 1MB
huge_pages = off
effective_cache_size = 550MB
effective_io_concurrency = 200

checkpoint_timeout = '15 min'	# range 30s-1d
checkpoint_completion_target = 0.9
max_wal_size = 512MB
min_wal_size = 64MB

wal_compression = on
wal_buffers = -1
wal_writer_delay = 200ms
wal_writer_flush_after = 1MB

default_statistics_target = 100
random_page_cost = 1.1

max_worker_processes = 2             # 9.6+
max_parallel_workers_per_gather = 1  # 9.6+
max_parallel_workers = 2             # 10+
#max_parallel_maintenance_workers = 1 # 11+
#parallel_leader_participation = on   # 11+

lc_messages = 'C.UTF-8'		# locale for system error message
lc_monetary = 'C'			# locale for monetary formatting
lc_numeric = 'C'			# locale for number formatting
lc_time = 'C'				# locale for time formatting
log_timezone = 'UTC'
timezone = 'UTC'
```

* Run DB
```bash
## Start PostgreSQL
docker-compose up -d atl-psql
# (optional) Analyze all DBs (mandatory after Restore DB) 
docker-compose exec atl-psql \
  time vacuumdb --all --analyze -U postgres
```

## 3. Run Jira
```bash
## Clear Jira-dir (if you need it)
docker run -it --rm -v ${PWD}:/mnt alpine sh -c "rm -rf /mnt/jira/*"

## Start Jira
docker-compose up -d atl-jira
```

## 4. Run Confluence
```bash
## Clear Jira-dir (if you need it)
docker run -it --rm -v ${PWD}:/mnt alpine sh -c "rm -rf /mnt/confluence/*"

## Start Confluence
docker-compose up -d atl-confluence
```

## 5. Setup Nginx
### Issue SSL-certificates
Issue certificates for Jira/Confluence as you wish.  
I'm prefer to use [ACME.SH](https://acme.sh/) as my favorite Let's Encrypt client.

### Configure Nginx
You need to change `nginx/conf/jira.conf` and `nginx/conf/confluence.conf` for your
server_name, certificates

### Run Nginx
```bash
docker-compose up -d nginx
```

## 6. Setup Jira

### 6.1 Useful plugins

#### CRM for Jira - Customers & Sales
**Marketplace URL**: https://marketplace.atlassian.com/apps/1211588/crm-for-jira-customers-sales  
**Get TRY-License URL**: https://my.atlassian.com/addon/try/ru.teamlead.jira.plugins.teamlead-crm-plugin-for-jira

#### Tempo Timesheets: Time Tracking & Report
**Marketplace URL**: https://marketplace.atlassian.com/apps/6572/tempo-timesheets-time-tracking-report  
**Get TRY-License URL**: https://my.atlassian.com/addon/try/is.origo.jira.tempo-plugin

#### Zephyr for Jira - Test Management
**Marketplace URL**: https://marketplace.atlassian.com/apps/1014681/zephyr-for-jira-test-management   
**Get TRY-License URL**: https://my.atlassian.com/addon/try/com.thed.zephyr.je

## 7. Setup Confluence

# Backup DB
```bash
# Backup ALL psql DBs (and Users with Passwords)
docker-compose exec -T atl-psql \
  time pg_dumpall --clean --if-exists -U postgres  |  gzip > dump_all.sql.gz  
```

# Restore
К какой базе данных вы подключаетесь, здесь не важно, так как скрипт, созданный утилитой pg_dumpall,
будет содержать все команды, требующиеся для создания сохранённых баз данных и подключения к ним.
```bash
# Restore ALL psql DBs 
zcat dump_all.sql.gz |  docker-compose exec -T atl-psql \
  time psql -U postgres postgres
# Analyze all DBs (mandatory after Restore DB) 
docker-compose exec atl-psql \
  time vacuumdb --all --analyze -U postgres
```
