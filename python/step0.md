Установим venv и библиотеку gigachat: 

`prepare.sh && . ~/.bashrc`{{execute}}

Получем [токен](/proxy/api/v1/token) 

закидываем access_token в заготовку:
`simple.py`{{open}}

запускаем
`python simple.py`{{execute}}

возможные ошибки от прокси:
- `400`, "message":"no valid proxy token found in header" - не указан параметр access_token или указан некорректно
- `403`, "message":"proxy token not found" - время жизни токена истекло или такого токена не существует
- `429`, "message":"too many requests" - превышен лимит запросов (текущий - 10 запросов в минуту на токен), необходимо повторить запрос через 1 мин

