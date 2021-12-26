Для демонстрации разграничения доступа к апи настроим 2 плана подписки:
* публичный доступ на /get/** ендпоинты с  GET типом запросов
* полный доступ с API KEY

Откроем описание апи и изучим секцию "plans"

`httpbin-1.0.0.json`{{open}}

Импортируем файл с описанием апи командой:

`curl  -u admin:admin -H "Content-Type:application/json;charset=UTF-8" -d @httpbin-1-0-0.json    http://localhost:32100/management/organizations/DEFAULT/environments/DEFAULT/apis/import`{{execute}}

Стартуем апи командой
`curl  -u admin:admin -X POST http://localhost:32100/management/organizations/DEFAULT/environments/DEFAULT/apis/70baa1f6-0b52-4413-baa1-f60b526413ec?action=START`{{execute}}

Пробуем выполнить запрос к публичному апи, опубликованному через api gateway:

`curl -v http://localhost:32100/gateway/httpbin/get`{{execute}}

Запрос успешно выполняется

Пробуем выполнить запрос к закрытой части апи:

`curl -v -XPOST http://localhost:32100/gateway/httpbin/post`{{execute}}

Получаем ошибку доступа, не хватает полномочий. Получим ключ для доступа к этой части апи.