# GitLab Omnibus

## About
Docker-compose with GitLab & Container Registry.

## Installation

### Get SSL-certs
Issue SSL-cert with **Let's Encrypt** (by acme.sh, for example) or buy it, if you wish. 

### Make & edit .env file
Configure Domain-name and ports in **.env** file
```bash
cp .env.example .env
nano .env
```

### Make & edit docker-compose.yml file
```bash
cp docker-compose.example.yml docker-compose.yml
nano docker-compose.yml
```
By default, docker-compose.example.yml is configured for Standalone installation (without frontend Nginx).   
In this case, SSL-termination is performed by **internal Nginx** for both: Web- and Docker-Container- traffic.
```yaml
        nginx['listen_https'] = true
        nginx['redirect_http_to_https'] = true
        nginx['ssl_certificate'] = "$SSL_FULLCHAIN"
        nginx['ssl_certificate_key'] = "$SSL_PRIVKEY"
        # ...
    ports:
      - "80:80"
      - "443:443"
```

OR you can use frontend Nginx for GitLab:
```yaml
        nginx['listen_port'] = 80
        nginx['listen_https'] = false
        nginx['redirect_http_to_https'] = false
        nginx['proxy_set_headers'] = {
          'Host' => '$GITLAB_HOSTNAME',
          'X-Forwarded-Proto' => 'https',
          'X-Forwarded-Ssl' => 'on',
        }
        # ...
    ports:
      - "80:80"
```
Copy **nginx-gitlab-example.conf** to the Nginx sites-config dir, and edit Domain-name and SSL- settings. 

## Update GitLab 
```bash
cd gitlab

docker-compose pull
docker-compose down
docker-compose up -d
docker system prune -f
```
