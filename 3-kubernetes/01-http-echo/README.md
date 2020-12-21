# 01. HTTP-echo
Very simple example for Kubernetes:
* Create personal **Namespace** for
* Start few **Pods** with web-service 'HTTP(S)-echo'
* Make **Service** for them
* Make **Ingress-rule** for routing '/echo/' to the Service

## Install

### Create Namespace
Create personal Namespace, primarily
```console
$ kubectl create namespace echo
## OR
$ kubectl apply -f echo-namespace.yaml

namespace/echo created
```

### Start Pods
Make Deployment of Pods (2, for beginning)
```console
$ kubectl apply -f echo-deployment.yaml
deployment.apps/echo-deployment created

$ kubectl get pod -n echo
NAME                               READY   STATUS    RESTARTS   AGE
echo-deployment-85b875c49d-nt7ww   1/1     Running   0          32s
echo-deployment-85b875c49d-kfrqk   1/1     Running   0          32s
```

### Make Service
For network interaction with Pods, you need to create a Service
```console
$ kubectl apply -f echo-service.yaml 
service/echo-service created
```

### Define Ingress-rule
HTTP(S) requests are serving by Ingress-Controller (and Rules)
```console
$ kubectl apply -f 01-http-echo/echo-ingress.yaml 
Warning: networking.k8s.io/v1beta1 Ingress is deprecated in v1.19+, unavailable in v1.22+; use networking.k8s.io/v1 Ingress
ingress.networking.k8s.io/echo-ingress created
```

### Scaling
```console
$ kubectl scale -n echo deployment echo-deployment --replicas=4
deployment.apps/echo-deployment scaled

$ kubectl get pod -n echo
NAME                               READY   STATUS    RESTARTS   AGE
echo-deployment-85b875c49d-nt7ww   1/1     Running   0          12m
echo-deployment-85b875c49d-kfrqk   1/1     Running   0          12m
echo-deployment-85b875c49d-9dskx   1/1     Running   0          66s
echo-deployment-85b875c49d-6pcg2   1/1     Running   0          66s
```

## Uninstall
You can simply delete namespace ;-)
```console
$ kubectl delete namespace echo
## OR
$ kubectl delete -f echo-namespace.yaml

namespace "echo" deleted
```
