### Рейтлимит запросов

В текущем плане подписки нашего приложения установлен рейтлимит 3 запроса/мин. Еще несколько раз вызовем функцию и получим следующий ответ:
```
{"message":"Rate limit exceeded ! You reach the limit of 3 requests per 1 minutes","http_status_code":429}
```
Давайте изменим настройки рейтлимита.  
Откроем интерфейс gravitee apim по ссылке [gravitee ](https://[[HOST_SUBDOMAIN]]-32100-[[KATACODA_HOST]].environments.katacoda.com/)  

Перейдем в настройки плана для нашего api и увеличим количество доступных запросов до 5 в минуту.

TODO pic