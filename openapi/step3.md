### Авторизация в gravitee apim
Откроем интерфейс gravitee apim по ссылке [gravitee ](https://[[HOST_SUBDOMAIN]]-32100-[[KATACODA_HOST]].environments.katacoda.com/)  и авторизуемся в нем  
```
права администратора
user: admin
pasword: admin

права пользователя
user: user
password: password
```
### Маппинг serverless функции
Подключем ранее созданную функцию fn1 через api gateway. Для этого:
1. после авторизации в интерфейсе переходим на вкладку "APIs"
2. нажимаем "+" в правом нижнем углу и выбираем вариант "import"
3. выбираем "import from link" и формат "API Definition"
4. ссылка для загрузки `https://raw.githubusercontent.com/valex1984/katacoda-scenarios/sbercode/openapi/assets/fn1.json`

и вызовем по ссылке [fn1](https://[[HOST_SUBDOMAIN]]-32100-[[KATACODA_HOST]].environments.katacoda.com/gateway/serverless) 