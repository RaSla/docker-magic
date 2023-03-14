# K8S User Management

## Create Service Account for limited namespace

[2019/12/23/kak-sozdat-v-kubernetes-akkaunt-polzovatelja](https://itisgood.ru/2019/12/23/kak-sozdat-v-kubernetes-sluzhbu-akkaunt-polzovatelja-i-ogranichte-ego-odnim-prostranstvom-imen-s-pomoshhju-rbac/)

<https://stackoverflow.com/questions/42170380/how-to-add-users-to-kubernetes-kubectl>

```shell
## 1. Create NameSpace and ServiceAccount
$ kubectl create namespace test
$ kubectl create serviceaccount test-user -n test
serviceaccount/test-user created
## (or)
$ kubectl apply -f sa-test-user.yml

## Check API for RBAC
$ kubectl api-versions| grep  rbac
rbac.authorization.k8s.io/v1
rbac.authorization.k8s.io/v1beta1

## 2. Create Role for namespace
$ kubectl apply -f role-test-admin.yml
role.rbac.authorization.k8s.io/admin created
$ kubectl get roles -n test
NAME    CREATED AT
admin   2023-03-13T06:07:48Z

## 3. Create RoleBinding
$ kubectl apply -f rb-test-admin.yml 
rolebinding.rbac.authorization.k8s.io/test-admin created
$ kubectl get rolebindings -n test
NAME         ROLE         AGE
test-admin   Role/admin   23s

## 4. Create kube-config for user
# Get related secret
$ export NS="test"
$ export K8S_USER="test-user"
$ kubectl describe sa -n $NS test-user | grep token
Mountable secrets:   test-user-token-f7fsd
Tokens:              test-user-token-f7fsd
# (or)
$ token=$(kubectl get sa -n $NS test-user -o json | jq -r .secrets[].name)
$ echo $token
test-user-token-f7fsd

# get User Token
$ utoken=$(kubectl -n ${NS} describe secret $(kubectl -n ${NS} get secret | (grep ${K8S_USER} || echo "$_") | awk '{print $1}') | grep token: | awk '{print $2}'\n)
$ echo $utoken
eyJhbGciOiJSUzI1NiIsImtpZCI6IktjNGNEQ25WaEVuRlN4TjVZb1dCR3ZjcjJwS1dnQ1NXR1EyZ1EwWlpKWkEifQ.eyJpc3MiOiJrdWJlcm5ldGVzL3NlcnZpY2VhY2NvdW50Iiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9uYW1lc3BhY2UiOiJ0ZXN0Iiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9zZWNyZXQubmFtZSI6InRlc3QtdXNlci10b2tlbi1mN2ZzZCIsImt1YmVybmV0ZXMuaW8vc2VydmljZWFjY291bnQvc2VydmljZS1hY2NvdW50Lm5hbWUiOiJ0ZXN0LXVzZXIiLCJrdWJlcm5ldGVzLmlvL3NlcnZpY2VhY2NvdW50L3NlcnZpY2UtYWNjb3VudC51aWQiOiJlNmEzMmE2My1iNzkwLTRlNzAtYTI4ZC1hOWIwMTM2OGFkMTciLCJzdWIiOiJzeXN0ZW06c2VydmljZWFjY291bnQ6dGVzdDp0ZXN0LXVzZXIifQ.mNkgBKVa3yJWmwzQTwsJj0idjgiqnPR7No4exzGrElsn9HENncq0ThjjSNetM8mhGnn6HTmzA61Luwclw4-9jcgHrcrWXSR0VzOHPXW2DnfcWxQDTTZCV-1ZPLll6uG8cLRrFVbsRAHfoEqkqj21tiNghyxBymemsoqp2l-AWVJHXpNqy4LZLvclBESn1bO1uA3GJpsUyR2Kt_kNNKARSLZ1LnKLIv8aW282TgrafvKtnrBx5vfQ8hsAPrH4QJsBW6yBzptm82ANffRS7gXy9-jubKxFmc4yDAqM7NXdmtuQ0HzYXy-wsblLzk8tw3583gnJ6nkLk_m7ItfrWB0HyQ

# get User Cert
$ ucert=$(kubectl  -n ${NS} get secret `kubectl -n ${NS} get secret | (grep ${K8S_USER} || echo "$_") | awk '{print $1}'` -o "jsonpath={.data['ca\.crt']}")
$ echo $ucert
LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSUJkakNDQVIyZ0F3SUJBZ0lCQURBS0JnZ3Foa2pPUFFRREFqQWpNU0V3SHdZRFZRUUREQmhyTTNNdGMyVnkKZG1WeUxXTmhRREUyTnpjMU56STFNRGN3SGhjTk1qTXdNakk0TURneU1UUTNXaGNOTXpNd01qSTFNRGd5TVRRMwpXakFqTVNFd0h3WURWUVFEREJock0zTXRjMlZ5ZG1WeUxXTmhRREUyTnpjMU56STFNRGN3V1RBVEJnY3Foa2pPClBRSUJCZ2dxaGtqT1BRTUJCd05DQUFTUXpMam85WWZjNzQ1bWhIWFMyNzJpelFPY2puM3JXWGxuL2dMWjhyRUEKZms4aFk1eVZKNStuRVZiL3JMNmF1ZElTV1NUV3kzTkxnaWI2UjB1RzRobFFvMEl3UURBT0JnTlZIUThCQWY4RQpCQU1DQXFRd0R3WURWUjBUQVFIL0JBVXdBd0VCL3pBZEJnTlZIUTRFRmdRVVlJWnlXTFFrdk1UR29JbkpGcjVYCit6YWMxQlV3Q2dZSUtvWkl6ajBFQXdJRFJ3QXdSQUlnTDY2ZncxdjNlWHBxMDBWV1AzTzhJWVRLQ0tQM3Z0Z3AKZnlremwybGpjeGNDSUhRNElJTDlaU1I5MkRXM2dBRTRVYVJWcmtLTzVmREpuREEzWnNBanJ6VDkKLS0tLS1FTkQgQ0VSVElGSUNBVEUtLS0tLQo=

# get cluster name of context
$ name=$(kubectl config get-contexts $c | awk '{print $3}' | tail -n 1)

# get endpoint of current context 
$ endpoint=$(kubectl config view -o jsonpath="{.clusters[?(@.name == \"$name\")].cluster.server}")
$ echo $endpoint
https://127.0.0.1:6443

# create kube-config file
$ cat <<EOF > kubeconfig-test.yml
apiVersion: v1
clusters:
- cluster:
    certificate-authority-data: $ucert
    server: $endpoint
  name: mycluster

contexts:
- context:
    cluster: mycluster
    namespace: test
    user: $K8S_USER
  name: test

current-context: test
kind: Config
preferences: {}

users:
- name: $K8S_USER
  user:
    token: $utoken
    client-key-data: $ucert
EOF

## Test kubeconfig
$ cp -f kubeconfig-test.yml ~/.kube/config
$ kubectl get po
No resources found in test namespace.
```
