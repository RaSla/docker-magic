# OpenConnect

Simple, but powerfull VPN solution !

## Server

1. Download the docker-compose : `git clone ...`
2. Change dir to it: `cd ocserv`
3. Create `ocserv` subdir & make it writable (for all): `mkdir -p ocserv && chmod 777 ocserv`
4. Run OpenConnect server: `docker compose up -d`
5. Add (few/some) user(s):

```console
$ docker compose exec ocserv ocpasswd -c /etc/ocserv/ocpasswd <user_name>
Enter password:
Re-enter password:
$
```

6. (optional) configure server by editing `ocserv/ocserv.conf` & restarting Compose  
   <https://ocserv.openconnect-vpn.net/ocserv.8.html>

## Client

1. Download client for you OS:
    * Linux: `apt install openconnect` (& `network-manager-openconnect-gnome` Network-Manager plugin)
    * Windows: <https://www.infradead.org/openconnect-gui/download/openconnect-gui-1.6.2-win64.exe>
    * OpenWRT: install `openconnect` package
2. Add connect-profile with params: URL, login, password

## See also

* <https://ocserv.openconnect-vpn.net/>
* <https://github.com/aminvakil/docker-ocserv/tree/master>
