# VaultWarden (unofficial Bitwarden® server)

Alternative implementation of the Bitwarden server API written in Rust and compatible with upstream Bitwarden clients.

Perfect for self-hosted deployment for the **storage of secrets** :

* Web-interface
* Store & management secrets
* Hierarchy: Organisations & Collections & Folders
* Users Access Control (separated by Organisations)
* "Send" - Password sharing (by URL)
* File attachments
* Vault API support
* Authenticator and U2F support

## Install

### (optional) Clear previous data

`$ docker run -it --rm -v $(pwd):/mnt -w /mnt busybox rm -rf vw-data/*`

### 1. Create folder for data

```console
$ mkdir -p -m 777 vw-data
```

### 2. Configure

* Generate ADMIN_TOKEN:

```console
$ docker run --rm -it vaultwarden/server /vaultwarden hash --preset owasp
Generate an Argon2id PHC string using the 'owasp' preset:

Password: 
Confirm Password: 

ADMIN_TOKEN='$argon2id$v=19$m=19456,t=2,p=1$LJk/I1nBSmasnWfwi2zKVpbf2Eq0Z4LX0sNMzhWmVp4$6HH3MA/EcKR5RsPY/uFx/AFH229ST2c1/HaWb2P0QTg'
```

* Put ADMIN_TOKEN's value into **.env** file

```console
$ cp .env.example .env
$ nano .env
```

* (Optional) Put your UID & GID into **.env** file

```console
$ id
uid=1000(admin) gid=1000(admin)...
$ nano .env
$ cp docker-compose.override.example.yml docker-compose.override.yml
```

* (Optional) Put your `DOMAIN` into **docker-compose.override.yml** file

```console
$ nano docker-compose.override.yml
```

### 3. Run Compose

Run docker-compose as usually:

```console
$ docker-compose up -d
```

* Admin-URL in web-browser: <http://localhost:8080/admin/> - enter ADMIN_TOKEN source value
* User-URL: <http://localhost:8080/>

Tip: You can change **ROOT_URL** in `DOMAIN` env-var.

## See also

* <https://hub.docker.com/r/vaultwarden/server> - Docker HUB
* <https://github.com/dani-garcia/vaultwarden/> - GitHub
* <https://github.com/dani-garcia/vaultwarden/wiki/> - Wiki
* <https://github.com/dani-garcia/vaultwarden/wiki/Deployment-examples#kubernetes> - Kubernetes setup examples
