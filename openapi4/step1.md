###  Создание и публикация функции через gravitee api gateway
Cоздадим функцию из темплейта и выполним ее сборку и деплой:
`faas-cli new --lang python3-sbercode apiv1 && faas-cli up -f apiv1.yml`{{execute}}

Дождемся, пока статус пода станет Ready.  
`kubectl wait -n openfaas-fn --for=condition=ContainersReady --timeout=5m --all pods`{{execute}}  

Импортируем файл с готовым описанием апи для нашей функции командой

`curl -u admin:admin -H "Content-Type:application/json;charset=UTF-8" -d @demoapi-1-0-0.json    http://localhost:32100/management/organizations/DEFAULT/environments/DEFAULT/apis/import`{{execute}}

Стартуем апи командой
`curl  -u admin:admin -X POST http://localhost:32100/management/organizations/DEFAULT/environments/DEFAULT/apis/32707a13-6fb4-4146-b07a-136fb4d1464c?action=START`{{execute}}

Пробуем выполнить запрос к апи, опубликованному через api gateway.

`curl -v http://localhost:32100/gateway/api/v1`{{execute}}

В случае успеха должен вернуться текст `Hello from OpenFaaS!`. Если получаете ответ "No context-path matches the request URI." - api gateway еще не успел развернуть endpoint. Попробуйте повторить через 3-5 сек.