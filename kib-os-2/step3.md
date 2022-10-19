Для настройки нужно знать имя проекта, а также имя Control Plane, к которой подключен проект. Найдем название в описании проекта

Получим имя проекта

`oc project -q`{{execute}}

Получим имя Control Plane

`oc describe project $(oc project -q) | grep member-of | head -n 1 | cut -d '=' -f2`{{execute}}

Создадим Deployment Ingress Gateway. Для настройки требуется:
* имя проекта
* имя Control Plane
* название сервиса Ingress. Название должно содержать КЭ АС. Это требование сопровождения Istio
* перечень портов, используемых для организации трафика через Ingress Proxy. Все порты должны быть объявлены в Service Ingress Gateway
* secret, содержащий сертификаты, которые будут использоваться для настройки соединений. Они должны пыть монтированы в Deployment Ingress Gateway (см. блоки Volumes и VolumeMounts)

Заполните имена проекта и Control Plane в файле

`ingress-params.env`{{open}}

`oc process -f ingress-template.yml --param-file ingress-params.env -o yaml > conf.yml
oc apply -f conf.yml`{{execute}}

В логах пода Ingress Gateway необходимо дождаться сообщения

`Envoy Proxy is ready`

`oc logs $(oc get pods -o name | grep ingress | head -n 1)`{{execute}}
