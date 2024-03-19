# PHP-app

Compose for PHP-apps

* **Nginx** - frontend web-server & API-router;
* **PHP** app/micro-service ;
* **bash-scripts** for benchmark web-apps by SIEGE & WRK tools:

## Prepare

* make `.env` file from example: `cp .env.example .env`
* edit `.env`
* (optional) make & edit `docker-compose.override.yml` from example file

## Configure PECL modules

**PHP7+** : You can enable or disable PECL modules (examples: MySQL, pgSQL, Redis etc.)
by setting BUILD-ARGs in `docker-compose.override.yml`

## Usage

* `docker-compose up` - Run in foreground
* `docker-compose up -d` - Run in background
* `docker-compose stop` - Stop
* `docker-compose down` - Stop and Clean

### Benchmark

* `./siege-catalog.sh` - benchmark with SIEGE
* `./wrk-catalog.sh` - benchmark with WRK
* `urls-app.txt` - file with URLs list for benchmark
