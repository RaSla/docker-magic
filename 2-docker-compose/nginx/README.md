# Nginx

## About
**NGINX** - perfect web- and proxy- server! See also:
* [Nginx en-docs](https://nginx.org/en/docs/)
* [Nginx Docker](https://hub.docker.com/_/nginx/)
* [Nginx GitHub](https://github.com/nginx/nginx)

## Usage & Tuning
* (optional) Configure Compose for the "Running as local-user"
* (optional) Configure website configs
* Run Compose in daemon (background) mode

### (optional) Running as local-user
```bash
## Copy **.env** from **.env.example** and edit it.
cp .env.example .env

## Find out your ID
id
uid=1000(rasla) gid=1000(rasla)
## Edit USER_UID and USER_GID
nano .env

## Make 'docker-compose.override.yml'
cp docker-compose.override.example.yml docker-compose.override.yml
```

### (optional) Configure website configs
Compose have few examples:
* **elite-games.ru.conf** - Redirect: http(s)://elite-games.ru -> https://www.elite-games.ru
* **rasla.ru.conf** - Front-proxy to backend
* **www.rasla.ru.conf** - Redirect: http(s)://www.rasla.ru -> https://rasla.ru

You can setup TLS settings fast and conveniently. Include some of them for every website:
* conf.d/**_tls-10.config** - TLSv1.0 - TLSv1.3 
* conf.d/**_tls-12.config** - TLSv1.2 - TLSv1.3 **(recommended)**
* conf.d/**_tls-12-cbc.config** - TLSv1.2 - TLSv1.3 (same as _tls-12.config + ECDHE-RSA-AES128-SHA256) 
* conf.d/**_tls-13.config** - TLSv1.3 only
* conf.d/**_tls-cert-snakeoil.config** - self-signed SSL-certificate (valid: 2020 - 2030 years) 
* conf.d/**_tls-common.config** - include: external DNS-resolver (for ssl_stapling), OCSP-stapling, SSL-session
* conf.d/**_tls-csp-report.config** - Content-Security-Policy-Report
* conf.d/**_tls-hsts.config** - [HTTP Strict-Transport-Security](https://en.wikipedia.org/wiki/HTTP_Strict_Transport_Security)
* conf.d/**_tls-xss-block.config** - XSS Protection

## Notes

### TLSv1.0
TLSv1.0 is deprecated for widespread use. 
If you need to use it, first create personal DH parameters :
```bash
cd docker-magic/2-docker-compose/nginx
openssl dhparam -out conf/_dhparam.pem 2048
``` 

### 
