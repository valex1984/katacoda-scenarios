Запустим экземпляр приложения для обработки HTTP-запросов

Изучите конфиги для запуска сервера. Обратите внимание на объект Service

`server.yml`{{open}}

`oc apply -f server.yml`{{execute}}

Дождемся, пока под с сервером запустится

`oc get pods | grep server`{{execute}}
