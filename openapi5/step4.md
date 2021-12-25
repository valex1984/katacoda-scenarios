### Рейтлимит запросов

В текущем плане подписки нашего приложения установлен рейтлимит 3 запроса/мин. Еще несколько раз вызовем функцию и получим следующий ответ:
```
{"message":"Rate limit exceeded ! You reach the limit of 3 requests per 1 minutes","http_status_code":429}
```
Давайте изменим настройки рейтлимита.  
Откроем интерфейс gravitee apim по ссылке [gravitee ](https://[[HOST_SUBDOMAIN]]-32100-[[KATACODA_HOST]].environments.katacoda.com/)  

Перейдем в настройки плана для нашего api и увеличим количество доступных запросов до 5 в минуту.

![App_](./assets/openapi5-3.png) 

Опубликуем изменения

![App_](./assets/openapi5-4.png) 

проверим изменения запросом:

`curl -H @apikey http://localhost:32100/gateway/fn2`{{execute}}


После 5 запросов должен быть ответ

```
{"message":"Rate limit exceeded ! You reach the limit of 5 requests per 1 minutes","http_status_code":429}
```