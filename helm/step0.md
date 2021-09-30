Для того, чтобы запустить Кластер кубернетеса надо выполнить: 

`launch.sh`{{execute}}

Далее установим env KUBECONFIG

`export KUBECONFIG=/etc/rancher/k3s/k3s.yaml `{{execute}}

Добавим helm репозиторий с nexus (proxy to bitnami)

`helm repo add bitnami http://nexus:8081/repository/bitnami/`{{execute}}
"bitnami" has been added to your repositories

Поищем чарт

`helm search repo zoo`{{execute}}
```
NAME                    CHART VERSION   APP VERSION     DESCRIPTION                                       
bitnami/zookeeper       7.4.5           3.7.0           A centralized service for maintaining configura...
```

и установим его

`helm install zk bitnami/zookeeper`{{execute}}
NAME: zk  
LAST DEPLOYED: Thu Sep 30 07:01:51 2021  
NAMESPACE: default  
STATUS: deployed  
REVISION: 1  
TEST SUITE: None  
NOTES:  
** Please be patient while the chart is being deployed **