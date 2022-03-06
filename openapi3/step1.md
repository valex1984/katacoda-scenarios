### Создание serverless функции OpenFaas
Для создания структуры директорий новой функции из темплейта выполним команду:
`faas-cli new --lang python3-sbercode apiv1`{{execute}}
Данная команда ищет темплейт с именем python3-sbercode (мы скачали его при подготовке окружения) и создает на его основе скелет функции в текущей директории. Результат можно посмотреть в директории apiv1

Выполним сборку и деплой функции командой:
`faas-cli up -f apiv1.yml`{{execute}}

Проверить статус можно командой:
`kubectl get po -n openfaas-fn`{{execute}}
Дождемся, пока статус пода станет Ready
```
NAME                   READY   STATUS    RESTARTS   AGE
apiv1-794f59b5fd-448pd   1/1     Running   0          14s
```

### Публикация функции через gravitee api gateway

Импортируем файл с готовым описанием апи для нашей функции командой

`curl -u admin:admin -H "Content-Type:application/json;charset=UTF-8" -d @demoapi-1-0-0.json    http://localhost:32100/management/organizations/DEFAULT/environments/DEFAULT/apis/import`{{execute}}

Стартуем апи командой
`curl  -u admin:admin -X POST http://localhost:32100/management/organizations/DEFAULT/environments/DEFAULT/apis/32707a13-6fb4-4146-b07a-136fb4d1464c?action=START`{{execute}}

Пробуем выполнить запрос к апи, опубликованному через api gateway.

`curl -v http://localhost:32100/gateway/api/v1`{{execute}}

В случае успеха должен вернуться текст `Hello from OpenFaaS!`. Если получаете ответ "No context-path matches the request URI." - api gateway еще не успел развернуть endpoint. Попробуйте повторить через 3-5 сек.

Мы успешно собрали и развернули простейшую функцию в кубернетес, а также опубликовали ее через api gateway.