# HELM

This is the HELM-chart example.

More complex example of HELM-repo you can see at: <https://github.com/RaSla/charts>

## Create HELM-chart
```console
## Create chart-template
$ helm create src/echo
## Edit chart-files...

## (development)
$ kubectl create namespace echo
$ cp config-echo.example.yaml _config-echo1.yml

$ helm template test1 -n echo -f _config-echo1.yml src/echo/

## (development) Apply chart before publish
$ helm upgrade --install test1 -n echo -f _config-echo1.yml src/echo/

$ helm uninstall test1 -n echo
```

## Rollback CHART
if something goes wrong after chart's upgrade - you can do `rollback`
```console
$ kubectl get po -n echo
NAME                          READY   STATUS    RESTARTS   AGE
test1-echo-75f6b7c867-286dw   1/1     Running   0          13m
test1-echo-75f6b7c867-sjzgg   1/1     Running   0          13m
test2-echo-7f6c959dfb-6rxnw   1/1     ImagePullBackOff  0         1m2s

$ helm history test2 -n echo
REVISION     UPDATED                      STATUS          CHART           APP VERSION     DESCRIPTION                                                                                                                                                                                                                                                                                                                                                                                                                                                                           
1            Mon Mar 27 20:19:06 2023     superseded      echo-0.1.0      0.1.0           Install complete                                                                                                                                                                                                                                                                                                                                                                                                                                                                      
2            Mon Mar 27 20:19:45 2023     superseded      echo-0.1.0      0.1.0           Upgrade complete                                                                                                                                                                                                                                                                                                                                                                                                                                                                      
3            Mon Mar 27 20:21:28 2023     failed          echo-0.1.0      0.1.0           Upgrade "test2" failed: cannot patch "test2-echo" with kind Ingress: Ingress.extensions "test2-echo" is invalid: spec.rules[0].host: Invalid value: "*": a wildcard DNS-1123 subdomain must start with '*.', followed by a valid DNS subdomain, which must consist of lower case alphanumeric characters, '-' or '.' and end with an alphanumeric character (e.g. '*.example.com', regex used for validation is '\*\.[a-z0-9]([-a-z0-9]*[a-z0-9])?(\.[a-z0-9]([-a-z0-9]*[a-z0-9])?)*')
4            Mon Mar 27 20:22:00 2023     deployed        echo-0.1.0      0.1.0           Upgrade complete
$ helm rollback test2 2 -n echo
Rollback was a success! Happy Helming!

$ helm ls -A
NAME    NAMESPACE       REVISION        UPDATED                                 STATUS          CHART           APP VERSION
test1   echo            1               2023-03-27 20:14:01.006709141 +0500 +05 deployed        echo-0.1.0      0.1.0      
test2   echo            5               2023-03-27 20:29:51.958102137 +0500 +05 deployed        echo-0.1.0      0.1.0

$ helm history test2 -n echo
REVISION     UPDATED                      STATUS          CHART           APP VERSION     DESCRIPTION                                                                                                                                                                                                                                                                                                                                                                                                                                                                           
1            Mon Mar 27 20:19:06 2023     superseded      echo-0.1.0      0.1.0           Install complete                                                                                                                                                                                                                                                                                                                                                                                                                                                                      
2            Mon Mar 27 20:19:45 2023     superseded      echo-0.1.0      0.1.0           Upgrade complete                                                                                                                                                                                                                                                                                                                                                                                                                                                                      
3            Mon Mar 27 20:21:28 2023     failed          echo-0.1.0      0.1.0           Upgrade "test2" failed: cannot patch "test2-echo" with kind Ingress: Ingress.extensions "test2-echo" is invalid: spec.rules[0].host: Invalid value: "*": a wildcard DNS-1123 subdomain must start with '*.', followed by a valid DNS subdomain, which must consist of lower case alphanumeric characters, '-' or '.' and end with an alphanumeric character (e.g. '*.example.com', regex used for validation is '\*\.[a-z0-9]([-a-z0-9]*[a-z0-9])?(\.[a-z0-9]([-a-z0-9]*[a-z0-9])?)*')
4            Mon Mar 27 20:22:00 2023     superseded      echo-0.1.0      0.1.0           Upgrade complete                                                                                                                                                                                                                                                                                                                                                                                                                                                                      
5            Mon Mar 27 20:29:51 2023     deployed        echo-0.1.0      0.1.0           Rollback to 2

$ kubectl get po -n echo
NAME                          READY   STATUS    RESTARTS   AGE
test1-echo-75f6b7c867-286dw   1/1     Running   0          21m
test1-echo-75f6b7c867-sjzgg   1/1     Running   0          21m
test2-echo-7f6c959dfb-6rxnw   1/1     Running   0          16m
```

### Uninstall CHART
```console
$ helm uninstall -n echo test1
release "test1" uninstalled
$ kubectl delete namespaces echo 
namespace "echo" deleted
```
