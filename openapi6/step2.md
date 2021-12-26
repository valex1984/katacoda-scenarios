### Создаем деплоймент с нагрузкой
Для моделирования потока запросов клиента создадим деплоймент, который каждую секунду будет вызывать наше апи.
Выполним команду деплоя:
`kubectl create deployment api-client --image=busybox:1.34 -- sh -c "while true; do wget \"--header=$(cat apikey)\"   http://localhost:8082/fn2; sleep 1; done"`{{execute}}  
Понаблюдаем за состоянием функции:
`watch -n1 faas-cli list`{{execute}}  
Заметим, что полве запуска нагрузки количество вызовов начало расти