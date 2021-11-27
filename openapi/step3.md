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
Подключем ранее созданную функцию fn1 через api gateway.  
1. после авторизации в интерфейсе переходим на вкладку "APIs"  
2. нажимаем "+" в правом нижнем углу и выбираем вариант "import"  
3. сохраняем файл описания api в формате  gravitee по [ссылке](https://raw.githubusercontent.com/valex1984/katacoda-scenarios/sbercode/openapi/assets/fn1.json)
4. выбираем "import from file" и указываем ранее сохраненный файл  
5. в верней части экрана видим предупреждение, что апи не синхронизировано. Нажимаем "deploy your API"  
6. нажимаем "START THE API"  
7. переходим по ссылке [fn1](https://[[HOST_SUBDOMAIN]]-32100-[[KATACODA_HOST]].environments.katacoda.com/gateway/serverless)  
Видим на странице результат вызова нашей функции