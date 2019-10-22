# docker-compose scaling demo
A short demo on how to use docker-compose to create a Web Service connected to a load balancer and a Redis (In-Memory Cache).

## Start up and running
Once you've cloned the project to your host we can now start our demo project.  
```bash
cd 2-docker-compose/py3-scale

docker-compose up
```

Open URL [localhost/](http://localhost/) in your web-browser.

Refresh the web-page several times - in the TTY-console you will see,
that your requests are served by 2 docker-containers of the `py3` service:
```text
py3_1    | 172.18.0.7 - - [22/Oct/2019 08:38:52] "GET / HTTP/1.1" 200 -
py3_2    | 172.18.0.7 - - [22/Oct/2019 08:38:54] "GET / HTTP/1.1" 200 -
py3_1    | 172.18.0.7 - - [22/Oct/2019 08:38:56] "GET / HTTP/1.1" 200 -
py3_2    | 172.18.0.7 - - [22/Oct/2019 08:38:57] "GET / HTTP/1.1" 200 -
```

This means that the Composition is working as it should. Stop it and run Composition in Daemon mode:
```bash
   Press [CTRL]+[C] in TTY-console to stop Compose

Stopping py3-scale_lb_1    ... done
Stopping py3-scale_py3_1   ... done
Stopping py3-scale_py3_2   ... done
Stopping py3-scale_redis_1 ... done

docker-compose up -d
```

## Scaling
Right now we have **2** docker-containers of the  `py3` service, as described in `docker-compose.yml`:
```yaml
  py3:
    # ... cut few YAML lines
    scale: 2
```

### Scale UP
Let's scale `py3` service from 2 instances to 4 instances.
```bash
docker-compose scale py3=4

Starting py3-scale_py3_1 ... done
Starting py3-scale_py3_2 ... done
Creating py3-scale_py3_3 ... done
Creating py3-scale_py3_4 ... done
``` 

Now refresh URL [localhost/](http://localhost/) in web-browser several times
or **`curl http://localhost/`** in TTY.  
We will see now, that the number of **"My hostname"** unique values has been increased up to 4.

To get a deeper understanding tail the logs of the stack to watch what happens each time you access your `py3` service.
```bash
docker-compose logs

    py3_3   | 172.17.0.7 - - [22/Oct/2019 08:39:40] "GET / HTTP/1.1" 200 -
    py3_4   | 172.17.0.7 - - [22/Oct/2019 08:39:41] "GET / HTTP/1.1" 200 -
    py3_1   | 172.17.0.7 - - [22/Oct/2019 08:39:43] "GET / HTTP/1.1" 200 -
    py3_2   | 172.17.0.7 - - [22/Oct/2019 08:39:46] "GET / HTTP/1.1" 200 -
    py3_3   | 172.17.0.7 - - [22/Oct/2019 08:39:48] "GET / HTTP/1.1" 200 -
    py3_4   | 172.17.0.7 - - [22/Oct/2019 08:39:49] "GET / HTTP/1.1" 200 -
```
Here's the output from my docker-compose logs after I curled my Application 6 times so it is clear that the round-robin is sent to all 4 `py3` docker-containers.

### Scale DOWN
The same way, you can scale `py3` service from 4 instances to 1 instance.
```bash
docker-compose scale py3=1

Stopping and removing py3-scale_py3_2 ... done
Stopping and removing py3-scale_py3_3 ... done
Stopping and removing py3-scale_py3_4 ... done
``` 
Now check URL [localhost/](http://localhost/) in web-browser or CURL several times.
And you will see that "My hostname" value is only one.

## Redis
**[Redis](https://redis.io/)** has been added to this Composition to show you,
that each `py3` docker-container works independently and correctly with shared resources.

You can see it by URL [localhost/py3/hits](http://localhost/py3/hits) .

Each request to [localhost/py3/hits](http://localhost/py3/hits) will increment the Counter "hits" in Redis:

```text
Python says:
 DateTime (UTC): "2019-10-22T13:34:31+00:00"
 My hostname is "38ebdaf62c59"

 Redis "hits": 11
```
```text
Python says:
 DateTime (UTC): "2019-10-22T13:35:34+00:00"
 My hostname is "9a60be79aaa7"

 Redis "hits": 12
```

### Persistent or In-Memory mode
By defaults Redis runs in Persistent-Mode (saving data to the Disk).

To switch Redis to "In-Memory only" mode, we give it additional parameters for launching docker-container:
```yaml
  redis:
    image: redis:5-alpine
    # DO NOT save to disk;  DB-count 16 -> 2
    command: ["sh", "-c", "exec redis-server --save \"\" --databases 2 "]
```
You can remove or customize `--save \"\"` argument, or comment entire **"command"** line, if you need Persistent Mode.


# Notes

## Compose file version
**Version 2.4** of docker-compose file is required to use the **"scale: 2"** variable in `docker-compose.yml`.

Version **3** of docker-compose file is intended for [Docker-Swarm](https://docs.docker.com/get-started/part4/) usage,
and do not support **"scale: X"** var.

## Load Balancer
You MUST to use the Load Balancer for scalable services with port-mapping to the Host-OS.

In NOT Swarm-mode: Docker-Proxy can't provide port-mapping,
 if you just use **ports: ...** for scalable service in `docker-compose.yml`:
```yaml
  py3:
    build:
      context: ./py3
      dockerfile: ./Dockerfile
    ports:
      - 80:8080
    scale: 2
```
`docker-compose up`:
```text
WARNING: The "py3" service specifies a port on the host.
If multiple containers for this service are created on a single host, the port will clash.

Creating py3-scale_py3_1   ... error
Creating py3-scale_py3_2   ... done

ERROR: for py3-scale_py3_1  Cannot start service py3:
 driver failed programming external connectivity on endpoint py3-scale_py3_1
(8fadf95b7ec380dbd9cff94e2351663b9557109be7ed8e10ff9c89e0bc741824):
 Bind for 0.0.0.0:80 failed: port is already allocated
```

### HAproxy from dockercloud
A benefit of running the HAProxy from Dockercloud is it automatically
detects the coming and going of docker-containers and doesn't require any changes.

### Nginx
You can use [Nginx](https://nginx.org/) instead of [dockercloud/haproxy](https://hub.docker.com/r/dockercloud/haproxy),
BUT you will need to reload/restart Nginx each time, when you scaling upsteam-service.

(because Nginx cannot dynamically update new IPs for upsteam docker-service)

## container_name is'n applicable with SCALE
You CAN'T use **container_name** and **scale** together,
because the **scale** generates a unique name for each container,
but it is hard-coded by the **container_name**. 
