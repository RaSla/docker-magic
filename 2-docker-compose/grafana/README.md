# Monitoring
Grafana + Prometheus (+ Alert Manager) = The most popular Monitoring-solution in 2019 !

**Prometheus** - polls Exporters and stores the received data.  
**Grafana** - displays data on graphs.  
**Alert Manager** - notifies about alarms according to the specified rules.

## Install
```console
# (optional) delete previous data
$ docker run -it --rm -v $(pwd):/mnt busybox rm -rf /mnt/{grafana_data,prometheus_data}
```

### Make data-dirs
```console
$ mkdir -p {grafana_data,prometheus_data}
$ chmod 777 {grafana_data,prometheus_data}
```

### Configure
Copy and edit `.env` file
```console
$ cp .env.example .env
$ nano .env
```
Copy and edit `prometheus.yaml` file
```console
$ cp prometheus/prometheus.example.yml prometheus/prometheus.yml
$ nano prometheus/prometheus.yml
```

### Run Compose
Run 
```console
$ docker-compose up -d
```

### Add data source
Open URL `<GRAFANA_ROOT_URL>` and logon as `admin` user with password (`GRAFANA_PASSWORD` value from `.env` file)
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

### Configure Prometheus


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

