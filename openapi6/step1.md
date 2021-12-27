###  Создание и публикация функции через gravitee api gateway
Cоздадим функцию из темплейта и выполним ее сборку и деплой:

`faas-cli new --lang python3-sbercode fn2 && faas-cli up -f fn2.yml`{{execute}}

Для автоматизации импорта и запуска апи, создания и подтверждения подписки используем скрипт:
`publish_and_subscribe.sh`{{open}}

Выполним скрипт:
`~/publish_and_subscribe.sh`{{execute}}

Далее проверим, что апи опубликовано и доступно:

`curl -H @apikey http://localhost:32100/gateway/fn2`{{execute}}

Если все сделано верно - функция вернет дефолтный текст. Если получаете ответ "No context-path matches the request URI." - api gateway еще не успел развернуть endpoint. Попробуйте повторить через 3-5 сек.
```
Hello from OpenFaaS!
```