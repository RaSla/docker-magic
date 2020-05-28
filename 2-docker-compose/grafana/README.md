# Monitoring
Grafana + Prometheus (+ Alert Manager) = The most popular Monitoring-solution in 2019 !

**Prometheus** - polls Exporters and stores the received data.  
**Grafana** - displays data on graphs.  
**Alert Manager** - notifies about alarms according to the specified rules.

## Install
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

| ID    | Name                         | Description                   | Exporter (docker-image)   |
|-------|------------------------------|-------------------------------|---------------------------|
|  2129 | Windows Node                 | OS and HW metrics   (windows) | WMI exporter (win-binary) |
| 11074 | 1 Node Exporter EN           | OS and HW metrics     (linux) | prom/node-exporter        |
|  1860 | Node Exporter Full           | OS and HW metrics     (linux) | prom/node-exporter        |
|  3170 | ZFS                          | ZFS stats and details (linux) | prom/node-exporter        |
|  893  | Docker and system monitoring | Docker info by cAdvisor       | google/cadvisor           |
|  3662 | Prometheus 2.0               | self-metrics about Prometheus | Prometheus 2.x            |
|  4279 | RabbitMQ Monitoring          | for RabbitMQ up to 3.7        | kbudde/rabbitmq-exporter  |
|  763  | Redis Dashboard              | for Redis                     | oliver006/redis_exporter  |

