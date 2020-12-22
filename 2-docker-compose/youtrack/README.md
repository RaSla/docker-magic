# JetBrains YouTrack
Cool and modern project-management tool and knowledge base.

## Install

### 1. Create folders
Run `./_init.sh` script to make 4 folders with correct access-right.  
Or execute commands manualy:
```console
$ mkdir -p -m 750 {data,conf,logs,backups}
$ sudo chown -R 13001:13001 {data,conf,logs,backups}

$ ls -al
drwxr-x---  2 13001 13001 4096 дек 22 12:06 backups
drwxr-x---  2 13001 13001 4096 дек 22 12:06 conf
drwxr-x---  2 13001 13001 4096 дек 22 12:06 data
drwxr-x---  2 13001 13001 4096 дек 22 12:06 logs
...
```

### 2. Run youtrack-compose
Run docker-compose as usually:
```console
$ docker-compose up -d
## Get INSTALL-TOKEN
$ docker-compose exec youtrack \
  cat /opt/youtrack/conf/internal/services/configurationWizard/wizard_token.txt
```

### 3. Configure and run Nginx
* Make SSL-certificate for website;
* Copy and edit **nginx_youtrack.conf** into Nginx's config folder;
* Run/restart Nginx web-server

### 4. Setup YouTrack (HTTPS-URL, Nginx)
* open your *YouTrack-URL* in web-browser
* paste *INSTALL-TOKEN* to continue
* select *SETUP*
* Choose:
    * **HTTP**
    * Base URL: **https** ://<HTTPS-URL without Port>
    * Application Listen Port: **8080**
    

## Uninstall
* Stop the Compose
* Run `./_purge.sh` script to delete 4 folders.  
Or delete them manualy:
```console
$ sudo rm -rf {data,conf,logs,backups}
```
