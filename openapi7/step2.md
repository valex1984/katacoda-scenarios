### Авторизация в gravitee apim
Откроем интерфейс gravitee apim по ссылке [gravitee ](https://[[HOST_SUBDOMAIN]]-32100-[[KATACODA_HOST]].environments.katacoda.com/)  и авторизуемся в нем  
```
права администратора
user: admin
pasword: admin
```
### Настройки плана публичного доступа
Изменим правила публичного доступа к апи, добавив доступ к /post url для POST запросов.

откроем импортированное апи и перейдем в дизайнер
//картинка
Выберем план demo-plan-get-only и компонент "Resource filtering"
//
Добавим в белый список еще один ендпоинт



