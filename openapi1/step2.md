### Запросы без авторизации
т.к. при деплое сервиса httpbin мы создали объект типа ingress, доступ к сервису можно осуществить из-за пределов k8s.  

Выполним GET запрос:
`curl -v localhost:32100/httpbin/get`{{execute}}

В ответе запроса получаем данные в виде json.

Выполним POST запрос:
`curl -v -XPOST localhost:32100/httpbin/post -H "Content-Type: application/json" -d'{"data":"test data here"}'`{{execute}}
В ответе получим json, который будет содержать в поле "json" данные нашего запроса.

При попытке выполнить данный запрос без явного указания типа POST(-XPOST) будет выполнен запрос типа GET, который вернет ошибку `405 Method Not Allowed`

### Запросы с авторизацией

 httpbin позволяет выполнить запрос с авторизацией. Т.к. сам сервис stateless, user/password задаются следующим образом:  
 /basic-auth/{user}/{password}  

 Выполним запрос:

`curl -v localhost:32100/httpbin/basic-auth/usr/pass`{{execute}}
получаем 401 ошибку, не хватает заголовка с авторизацией.  
Повторим запрос с нужными параметрами:

`curl -v -u usr:pass localhost:32100/httpbin/basic-auth/usr/pass`{{execute}}
Видим в запросе нужный заголовок  `Authorization: Basic dXNyOnBhc3M=` и 200 ответ.  

При желании можно самостоятельно поэкспериментировать с другими типами запросов согласно спецификации.