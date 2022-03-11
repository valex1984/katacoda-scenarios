Для демонстрации разграничения доступа к апи настроим 2 плана подписки:
* публичный доступ на /get/** endpointы с  GET типом запросов
* полный доступ с API KEY

Откроем описание апи и изучим секцию "plans"

`httpbin-1-0-0.json`{{open}}

Импортируем файл с описанием апи командой:

`curl  -u admin:admin -H "Content-Type:application/json;charset=UTF-8" -d @httpbin-1-0-0.json    http://localhost:32100/management/organizations/DEFAULT/environments/DEFAULT/apis/import`{{execute}}

Стартуем апи командой
`curl  -u admin:admin -X POST http://localhost:32100/management/organizations/DEFAULT/environments/DEFAULT/apis/70baa1f6-0b52-4413-baa1-f60b526413ec?action=START`{{execute}}

Пробуем выполнить запрос к публичному апи, опубликованному через api gateway:

`curl http://localhost:32100/gateway/httpbin/get`{{execute}}

Запрос успешно выполняется. Если получаете ответ "No context-path matches the request URI." - api gateway еще не успел развернуть endpoint. Попробуйте повторить через 3-5 сек.

Пробуем выполнить запрос к закрытой части апи:

`curl -XPOST http://localhost:32100/gateway/httpbin/post`{{execute}}

Получаем ошибку доступа 403, не хватает полномочий. Получим ключ для доступа к этой части апи.
Для этого запустим скрипт:

`generate_key.sh`{{execute}}

Скрипт генерирует приложение, запрос на подписку и подтверждение. Ключ для доступа записывает в файл ~/apikey

Проверим доступ с ключом к закрытой части апи:

`curl -XPOST -H @apikey http://localhost:32100/gateway/httpbin/post`{{execute}}

Запрос успешно выполняется.  
Далее посмотрим каким образом настроены ограничения доступа и добавим в публичный доступ еще один endpoint /post c типом запроса POST.