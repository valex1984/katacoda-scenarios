###  Создание новой версии
Создадим еще одну функцию из темплейта

`faas-cli new --lang python3-sbercode apiv2
Внесем изменения в нашу функцию.  
Для этого откроем в редакторе файл apiv2/handler.py и изменим текст, который выдается в ответ на запрос

<pre class="file" data-filename="./apiv2/handler.py" data-target="insert" data-marker="Hello from OpenFaaS!">
Version_2</pre>

Для публикации изменений пересоберем и опубликуем образ
`faas-cli up -f apiv2.yml `{{execute}}

Сборка образа упала с ошибкой. Что произошло? Не прошли юнит тесты, т.к. мы поменяли поведение функции.  
Поправим ошибку в файле fn1/handler_test.py

<pre class="file" data-filename="./apiv2/handler_test.py" data-target="insert" data-marker="Hello from OpenFaaS!">
Version_2</pre>

И затем заново запустим сборку и публикацию функции
`faas-cli up -f apiv2.yml `{{execute}}

Кубернетес развернет новый под с функцией и уничтожит предыдущую версию. Посмотреть статус деплоймента можно командой:
`kubectl get po -n openfaas-fn`{{execute}}

### Публикация новой версии

Импортируем файл с готовым описанием апи для нашей функции командой

`curl -u admin:admin -H "Content-Type:application/json;charset=UTF-8" -d @demoapi-2-0-0.json    http://localhost:32100/management/organizations/DEFAULT/environments/DEFAULT/apis/import`{{execute}}

Стартуем апи командой
`curl  -u admin:admin -X POST http://localhost:32100/management/organizations/DEFAULT/environments/DEFAULT/apis/70baa1f6-0b52-4413-baa1-f60b526413ec?action=START`{{execute}}

Пробуем выполнить запрос к апи, опубликованному через api gateway.

`curl -v http://localhost:32100/gateway/api/v2`{{execute}}

В случае успеха должен вернуться текст `Version_2`
