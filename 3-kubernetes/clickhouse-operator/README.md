# ClickHouse Operator
[Quick Start (GitHub)](https://github.com/Altinity/clickhouse-operator/blob/master/docs/quick_start.md)

## Install
```console
$ kubectl apply -f https://raw.githubusercontent.com/Altinity/clickhouse-operator/master/deploy/operator/clickhouse-operator-install.yaml
```

## Setup ClickHouse
Few examples are located at [GitHub.com/Altinity/clickhouse-operator/](https://github.com/Altinity/clickhouse-operator/blob/master/docs/chi-examples/)

### Standalone (01-demo.yaml)
```console
$ kubectl apply -f 01-demo.yaml -n demo
```

### Sharding and replicas
```console
$ nano 02-demo-2x-shard.yaml
$ kubectl apply -f 02-demo-2x-shard.yaml -n demo
```

### Persistent Volumes
```console
$ kubectl apply -f pv-local-ch.yml
$ kubectl get pv,pvc -A
NAME                           CAPACITY   ACCESS MODES   RECLAIM POLICY   STATUS      CLAIM   STORAGECLASS   REASON   AGE
persistentvolume/pv-local-ch   100Gi      RWO            Retain           Available           local-path              4s

$ nano 03-demo-pv.yaml
$ kubectl apply -f 03-demo-pv.yaml -n demo
$ kubectl get pv,pvc -A
NAME                           CAPACITY   ACCESS MODES   RECLAIM POLICY   STATUS   CLAIM                                              STORAGECLASS   REASON   AGE
persistentvolume/pv-local-ch   100Gi      RWO            Retain           Bound    demo/data-volume-template-chi-demo-03-demo-0-0-0   local-path              3m14s

NAMESPACE   NAME                                                                STATUS   VOLUME        CAPACITY   ACCESS MODES   STORAGECLASS   AGE
demo        persistentvolumeclaim/data-volume-template-chi-demo-03-demo-0-0-0   Bound    pv-local-ch   100Gi      RWO            local-path     2m33s
```
