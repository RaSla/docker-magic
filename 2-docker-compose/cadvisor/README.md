# Cadvisor

Analyzes resource usage and performance characteristics of running containers.

**cAdvisor** is metrics-exporter for Prometheus.

## Install

### Configure

(optional) Copy and edit `.env` file - if you wish to change external IPv4/Port for cAdvisor

```console
$ cp .env.example .env
$ nano .env
```

### Compose

```console
## start
$ docker-compose up -d

## Stop
$ docker-compose down
```

## See also

* <https://github.com/google/cadvisor> -
  cAdvisor (Container Advisor) provides container users an understanding of the resource usage
  and performance characteristics of their running containers.  
  (Grafana Dashboards: [Docker and system monitoring](https://grafana.com/grafana/dashboards/8321))
* <https://grafana.com/grafana/dashboards/8321-docker-monitoring-with-node-selection/>
  Grafana dashboard
