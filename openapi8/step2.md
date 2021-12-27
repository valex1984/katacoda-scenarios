### Авторизация в gravitee apim
Откроем интерфейс gravitee apim по ссылке [gravitee ](https://[[HOST_SUBDOMAIN]]-32100-[[KATACODA_HOST]].environments.katacoda.com/)  и авторизуемся в нем  
```
права администратора
user: admin
pasword: admin
```
### Добавление документации к апи
Перейдем в наше апи и добавим документацию типа "swagger"
![App_](./assets/openapi8-1.png) 
Сохраним изменения
![App_](./assets/openapi8-2.png) 
И затем опубликуем наше апи и сделаем его публично доступным на портале
![App_](./assets/openapi8-3.png) 

### Просмотр документации на портале

Перейдем в [портал](https://[[HOST_SUBDOMAIN]]-32100-[[KATACODA_HOST]].environments.katacoda.com/portal-ui) по ссылке и откроем наше апи
![App_](./assets/openapi8-4.png) 

Для потребителей нашего апи на портале доступна документация в спецификации openapi, которую можно изучить перед формированием запроса на подписку.
![App_](./assets/openapi8-5.png) 