С помощью команды docker build собираем локальный образ с меткой app:v1. Докер образ будет хранится локально.

```
docker build --network=host -t app:v1 app/
```{{execute}}

Запускаем это приложение с помощью docker-a в хост-сети, имя контейнера пусть будет app-v1

```
docker run -d --net=host --name=app-v1 app:v1 
```{{execute}}


Проверить работоспособность можно с помощью curl.

```
curl localhost:8000/probe
```{{execute}}

Наш сервис должен вывести счет матча в консоли

