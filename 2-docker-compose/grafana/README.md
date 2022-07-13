# Monitoring
Grafana + Prometheus + Alert Manager = The most popular Monitoring-solution in 2019-2022 !

**Prometheus** - polls Exporters and stores the received data.  
**Grafana** - displays data on graphs.  
**Alert Manager** - notifies about alarms according to the specified rules.

## Install
```console
# (optional) delete previous data
$ rm -rf {alertmanager,grafana,prometheus}/data
```

### Make data-dirs
```console
$ mkdir -p {alertmanager,grafana,prometheus}/data
```

### Configure
Copy and edit `docker-compose.yml` and `.env` file (especially env-vars: `USER_UID` & `USER_GID`)
```console
$ cp .env.example .env
$ nano .env
```
Copy and edit Compose & Config files
```console
$ cp prometheus/prometheus.example.yml prometheus/prometheus.yml
$ cp prometheus/rules.example.yml prometheus/rules.yml
$ cp docker-compose.example.yml docker-compose.yml

## (Optional)
$ cp blackbox/blackbox.example.yml blackbox/blackbox.yml
$ cp alertmanager/config.example.yml alertmanager/config.yml
```

### Run Compose
Run 
```console
$ docker-compose up -d
```

## Prometheus
Open URL `<PROM_EXTERNAL_URL>` try execute query: `up` or `up{job="node"}`.

You should see a list with data like this:
```text
up{instance="node_exporter:9100", job="node"} - 1
up{instance="cadvisor:8080", job="docker"} - 1
```

### Configure Prometheus
You could configure `prometheus/*.yml`, check them and do HOT-reload of Prometheus by:
```console
$ docker-compose exec prometheus promtool check rules /etc/prometheus/rules.yml
Checking /etc/prometheus/rules.yml
  SUCCESS: 9 rules found

$ docker-compose exec prometheus promtool check config /etc/prometheus/prometheus.yml
Checking /etc/prometheus/prometheus.yml
  SUCCESS: 1 rule files found
 SUCCESS: /etc/prometheus/prometheus.yml is valid prometheus config file syntax

Checking /etc/prometheus/rules.yml
  SUCCESS: 9 rules found

$ docker-compose exec prometheus kill -HUP 1
```

### Alert Rules
You can get many useful rules from <https://awesome-prometheus-alerts.grep.to/rules.html> !!!

## Grafana
Open URL `<GRAFANA_ROOT_URL>`, logon with "admin / admin" credentials and change admin-password.

First, default Datasource `Prometheus` already must be added (by `grafana/provisioning`).  
Check it by URL `<GRAFANA_ROOT_URL>/datasources`

### Add data source (manual)
1. Click **"Add your first data source"** on 
1. Select **"Prometheus"**
1. Define **"URL"**: `http://prometheus:9090/`
1. Click button **"Save & Test"**

### Add Dashboard
1. Open URL `<GRAFANA_ROOT_URL>/dashboard/import` on Basic-panel
1. `Import via grafana.com` - enter Dashboard ID **1860** and click button **"Load"**
1. Select `Prometheus`: **Prometheus** (from dropdown-list)
1. Click button **"Import"**

You will see your first data on Dashboard (select Time Ranges: `last 5 minutes`, for example).  
Repeat it again with Dashboard ID `8321`

### HW and OS metric exporter
* Install **Node_exporter** on target linux-hosts by Ansible role: [cloudalchemy.node-exporter](https://github.com/cloudalchemy/ansible-node-exporter)
* Install **WMI exporter** on target windows-hosts


## Exporters
The exporters are collecting Metrics. Prometheus is polling exporters and receive Metrics from them.

The most common exporters are listed below:
* **[Node_exporter](https://github.com/prometheus/node_exporter)** -
  Prometheus exporter for hardware and OS metrics exposed by ***NIX** kernels.  
  (Grafana Dashboards: [1 Node Exporter EN](https://grafana.com/grafana/dashboards/11074) 
  [Node Exporter Full](https://grafana.com/grafana/dashboards/1860) )
* **[WMI exporter](https://github.com/martinlindhe/wmi_exporter)** -
  Prometheus exporter for hardware and OS metrics is recommended for **Windows** users.  
  (Grafana Dashboards: [Windows Node](https://grafana.com/grafana/dashboards/2129))
* **[cAdvisor](https://github.com/google/cadvisor)** -
  cAdvisor (Container Advisor) provides container users an understanding of the resource usage
  and performance characteristics of their running containers.  
  (Grafana Dashboards: [Docker and system monitoring](https://grafana.com/grafana/dashboards/893))

The many other exporters you can find for specific applications.

## Grafana Dashboards

| ID    | Name                         | Description                   | Exporter (docker-image)           |
|-------|------------------------------|-------------------------------|-----------------------------------|
|  2129 | Windows Node                 | OS and HW metrics   (windows) | WMI exporter (win-binary)         |
| 11074 | 1 Node Exporter EN           | OS and HW metrics     (linux) | prom/node-exporter                |
|  1860 | Node Exporter Full           | OS and HW metrics     (linux) | prom/node-exporter                |
|  3170 | ZFS                          | ZFS stats and details (linux) | prom/node-exporter                |
|  893  | Docker and system monitoring | Docker info by cAdvisor       | gcr.io/google_containers/cadvisor |
|  3662 | Prometheus 2.0               | self-metrics about Prometheus | Prometheus 2.x                    |
|  4279 | RabbitMQ Monitoring          | for RabbitMQ up to 3.7        | kbudde/rabbitmq-exporter          |
|  763  | Redis Dashboard              | for Redis                     | oliver006/redis_exporter          |

