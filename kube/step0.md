Создаем и запускаем под.

This environment has a `launch.sh`{{execute}}

Проверяем статус кластера

`kubectl get nodes`{{execute}}

Заходим на рабочую ноду

`ssh node01`{{execute T2}}

Создадим под

<pre class="file" data-filename="./pod.yaml" data-target="replace">
apiVersion: v1
kind: Pod
metadata:
  name: hello-app
  labels:
    app: hello-app
spec:
  containers:
  - name: hello-app
    image: schetinnikov/hello-app:v1
    ports:
      - containerPort: 9080
</pre>

Отправляем его 
`kubectl apply -f pod.yaml`{{execute T1}}

Проверяем, что под создался
`kubectl get pods`{{execute T1}}

Как только запустится можем проверить, что он запустился на рабочей ноде 
`docker ps | grep hello`{{execute T1}}
`docker ps | grep hello`{{execute T2}}

Получить доступ к поду можно по ip. 

Для этого, вытаскиваем ip командой describe 

И ходим в него через wget

И ходим с мастерноды 


Для того, чтобы запустить в нескольких экземплярах будем использовать replicaset

Удалим текущий под

`kubectl delete -f pod.yaml`{{execute T1}}

<pre class="file" data-filename="./replicaset.yaml" data-target="replace">
apiVersion: apps/v1
kind: ReplicaSet
metadata:
    name: hello-rs-demo
spec:
    replicas: 3
    selector:
       matchLabels:
          app: hello-demo
    # pod template
    template:
       metadata:
          labels:
             app: hello-demo
       spec:
          containers:
          - name: hello-demo
            image: schetinnikov/hello-app:v1
            ports:
              - containerPort: 9080
</pre>

`kubectl apply -f replicaset.yaml`{{execute T1}}

`kubectl get pods`{{execute T1}}

Поменяйте на 4, а потом 2 и посмотрите, что будет после выполнения 

`kubectl apply -f replicaset.yaml`{{execute T1}}

Теперь удалим:

`kubectl delete -f replicaset.yaml`{{execute T1}}
