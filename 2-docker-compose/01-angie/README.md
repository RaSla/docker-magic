# Angie

## About

**Angie** - perfect web- and proxy- server (fork of Nginx)! See also:

* [Angie en-docs](https://angie.software/en/)

## Usage & Tuning

* (optional) Configure Compose by `docker-compose.override.yml` (copy from example)
* (optional) Configure SSL-folder in `docker-compose.override.yml`:
  uncomment 1 of 2 strings in `volumes` for `/etc/letsencrypt`
* (optional) Configure website configs in `angie/http.d/` folder
* Run Compose in interactive mode: `docker-compose up` (press CTRL+C or terminate)
* Run Compose in daemon (background) mode: `docker-compose up -d`

### (optional) Running as local-user

```shell
## Copy .env from .env.example and edit it.
$ cp .env.example .env

## Find out your ID
$ id
uid=1000(rasla) gid=1000(rasla)
## Edit USER_UID and USER_GID
$ nano .env

## Make & edit 'docker-compose.override.yml'
$ cp docker-compose.override.example.yml docker-compose.override.yml
$ nano docker-compose.override.yml
```

### (optional) Configure website configs

You can setup TLS settings fast and conveniently. Include some of them for every website:

* http.d/**_tls-10.config** - TLSv1.0 - TLSv1.3
* http.d/**_tls-12.config** - TLSv1.2 - TLSv1.3 **(recommended)**
* http.d/**_tls-12-cbc.config** - TLSv1.2 - TLSv1.3 (same as _tls-12.config + ECDHE-RSA-AES128-SHA256)
* http.d/**_tls-13.config** - TLSv1.3 only
* http.d/**_tls-cert-snakeoil.config** - self-signed SSL-certificate (valid: 2020 - 2030 years)
* http.d/**_tls-common.config** - include: external DNS-resolver (for ssl_stapling), OCSP-stapling, SSL-session
* http.d/**_tls-csp-report.config** - Content-Security-Policy-Report
* http.d/**_tls-hsts.config** -
  [HTTP Strict-Transport-Security](https://en.wikipedia.org/wiki/HTTP_Strict_Transport_Security)
* http.d/**_tls-xss-block.config** - XSS Protection

### (optional) Configure TCP-streams

TCP-forwarding is configuring in `stream{}` block.

You can copy & edit any example from [angie/stream.d](angie/stream.d) folder, if you wish.

### (optional) TLSv1.0

TLSv1.0 is deprecated for widespread use.
If you need to use it, first create personal DH parameters :

```shell
$ openssl dhparam -out angie/http.d/_dhparam.pem 2048
``` 

### (optional) htpasswd

For HTTP-auth you can generate files htpasswd-like.

* Step 1 - generate password_hash:

```shell
$ openssl passwd
Password: 
Verifying - Password: 
$1$M8Sd7iWX$bmY/qfO11zVAuEg8KepRO0
```

* Step 2 - copy hash in htpasswd-file:

```shell
$ cat angie/http.d/demo_htpasswd
## format: user:pwd_hash_by_openssl
# shell execute: openssl passwd
# L/P for example = test:test
test:$1$M8Sd7iWX$bmY/qfO11zVAuEg8KepRO0
```

* Step 3 - use htpasswd-file in server-/location- config -
  see [angie/http.d/angie.localhost.conf](angie/http.d/angie.localhost.conf) example

* Step 4 - reload Angie
* Step 5 - check your URL, for example: <http://angie.localhost/console/>. Login by `test` / `test`.
