## Норм Demo

Test changes xxx

<iframe style="width: 700px;height: 400px;" src="https://www.youtube-nocookie.com/embed/KeJJ34BvA7Q" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>


На этом обязательном шаге вам необходимо выступить в роли DevOps инженера команды и подготовить необходимую инфраструктуру для успешного прохождения упражнения

* учебный кластер Kubernetes
* Istio Service Mesh.

Выполните, пожалуйста, все необходимые шаги описанные ниже в этом шаге упражнения.

открыть файл `test.txt`{{open}}

copy-paste `echo "Hello World"`{{copy}}

## Kubernetes

Дождитесь подтверждения запуска кластера в терминале, должно появиться такое сообщение

```
master $ launch.sh
Waiting for "привет" Kubernetes to start...
Kubernetes started
```

## Istio

Запустите установку istio `/usr/local/bin/istio-install.sh`{{execute T1}}



`echo "Test" && echo "Test"`{{execute T1}}

`echo &quot;Test&quot; && echo "Test"`{{execute T1}}


Внимание! Установка может занять до 5 минут. 

## TroubleShoot

* перезагрузите страницу упражнения и начните сценарий заново.
