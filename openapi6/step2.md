### Создаем деплоймент с нагрузкой
Для моделирования потока запросов клиента создадим деплоймент, который каждую секунду будет вызывать наше апи.
`loader.yaml`{{open}}

Подставим наш ключ и применим манифест:
`sed "s/HEADER_PLACEHOLDER/$(cat apikey)/" loader.yaml| kubectl apply -f-`{{execute}}  
Понаблюдаем за состоянием функции:

`watch -n1 faas-cli list`{{execute}}  
Заметим, что после запуска нагрузки количество вызовов начало расти