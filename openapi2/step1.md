Импортируем файл с готовым описанием апи для нашей функции командой

`curl -H "Authorization: Basic YWRtaW46YWRtaW4=" -H "Content-Type:application/json;charset=UTF-8" -d @httpbin-1-0-0.json    http://localhost:32100/management/organizations/DEFAULT/environments/DEFAULT/apis/import`{{execute}}

Стартуем апи командой
`curl -H "Authorization: Basic YWRtaW46YWRtaW4=" -X POST http://localhost:32100/management/organizations/DEFAULT/environments/DEFAULT/apis/ 70baa1f6-0b52-4413-baa1-f60b526413ec?action=START -v`{{execute}}

Пробуем выполнить запрос к апи, опубликованному через api gateway.

`curl -v http://localhost:32100/gateway/httpbin/get`{{execute}}

получаем ответ от сервиса httpbin, В перечне заголовков видим специфичные для api gateway gravitee

```
    "X-Gravitee-Request-Id": "d50c941f-3fb7-4457-8c94-1f3fb734575e", 
    "X-Gravitee-Transaction-Id": "d50c941f-3fb7-4457-8c94-1f3fb734575e", 
```

Далее скорректируем маппинг ответов, чтоб данные заголовки не приходили.