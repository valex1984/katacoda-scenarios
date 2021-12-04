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
### Маппинг serverless функции через ui
Подключем ранее созданную функцию fn1 через api gateway.  
1. после авторизации в интерфейсе переходим на вкладку "APIs"  
2. нажимаем "+" в правом нижнем углу и выбираем вариант "import"  
3. сохраняем файл описания api в формате  gravitee по [ссылке](https://raw.githubusercontent.com/valex1984/katacoda-scenarios/sbercode/openapi/assets/fn1.json)
4. выбираем "import from file" и указываем ранее сохраненный файл  
5. в верней части экрана видим предупреждение, что апи не синхронизировано. Нажимаем "deploy your API"  
6. нажимаем "START THE API"  
7. переходим по ссылке [fn1](https://[[HOST_SUBDOMAIN]]-32100-[[KATACODA_HOST]].environments.katacoda.com/gateway/serverless)  
Видим на странице результат вызова нашей функции. 

### Разграничение доступа к api

Создадим еще одну функцию из темплейта

`faas-cli new --lang python3-sbercode fn2 && faas-cli up -f fn2.yml`{{execute}}

Импортируем файл описания апи для нашей функции командой

`curl -H "Authorization: Basic YWRtaW46YWRtaW4=" -H "Content-Type:application/json;charset=UTF-8" -d @serverless-example-1-0-0.json    http://localhost:32100/management/organizations/DEFAULT/environments/DEFAULT/apis/import`{{execute}}

Далее переходим в интерфейсе gravitee на вкладку APIs, находим импортированное api, стартуем и публикуем его.   
Согласно настройкам плана api fn2 публично не доступно, для обращения нужен API key. Проверим это запросом:

`curl -v http://localhost:32100/gateway/fn2`{{execute}}
Получаем 401 ошибку, нужен ключ.

Для получения ключа необходимо авторизоваться в [портале](https://[[HOST_SUBDOMAIN]]-32100-[[KATACODA_HOST]].environments.katacoda.com/portal-ui) user/password
- если авторизованы как admin - выходим из системы и входим под user
- перейти в "Applications" и нажать "CREATE AN APP"
- задать имя и описание, характеризуещее наше приложение, из которого мы запрашиваем доступ к api
- на шаге "Security" в случае с api key доступом поля заполнят не обязательно
- на шаге "Subscription" в поисковой строке пишем serverless и выбираем наше api, нажимаем "SUBSCRIBE". При необходимости оставляем комментарий для владельца
- на последнем шаге проверяем данные и нажимаем "CREATE THE APP"
Наше приложение создано, Администратору api направлен запрос на подписку. Подтвердим его.
Выходим из системы и авторизуемся в [консоли](https://[[HOST_SUBDOMAIN]]-32100-[[KATACODA_HOST]].environments.katacoda.com/) admin/admin
- в правом верхнем углу нажимаем на аватар и выбираем "Tasks"
- Видим запрос на подписку, нажимаем "VALIDATE"
- нажимаем "ACCEPT", Выбираем время действия подписки. С текущией даты, например, на месяц. По истечению доступ данному приложению к api будет автоматически прекращен. При необходимости можно оставить сообщение для владельца приложения
- после создания в интерфейсе доступен ключ, также администратор может изменить дату истечения подписки или приостановить/закрыть ее.
- ключ будет доступен пользователю user на [портале](https://[[HOST_SUBDOMAIN]]-32100-[[KATACODA_HOST]].environments.katacoda.com/portal-ui)  в созданном приложении.

Копируем ключ в файл `~/apikey` и заново пробуем выполнить запрос:
`curl -v -H "X-Gravitee-Api-Key:$(cat apikey|xagrs)" http://localhost:32100/gateway/fn2`{{execute}}
Если все сделано верно - функция вернет дефолтный текст.
