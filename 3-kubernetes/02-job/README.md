# 02. Job
Job - is the Pod for making some job ONCE (or REGULAR)

## Run Job
For example, we will run simple job 'echo "Hello" & sleep 3600' inside Kubernetes
```console
$ kubectl apply -f 02-job/alpine-job.yaml 
job.batch/alpine created

$ kubectl get pod 
NAME           READY   STATUS    RESTARTS   AGE
alpine-9jdmx   1/1     Running   0          39s
```

## Connect to the Pod
For example, we will execute few commands in this Pod:
```console
$ kubectl exec -it alpine-9jdmx -- sh
# hostname
alpine-9jdmx
# ps ax
PID   USER     TIME  COMMAND
    1 root      0:00 sleep 3600
   13 root      0:00 sh
   20 root      0:00 ps ax
# exit

$ hostname
devops-rasla
```
