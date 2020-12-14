Добавляем сервис в мониторинг прометеуса:

<pre class="file" data-filename="./targets/app.yml" data-target="replace">
- targets:
  - '127.0.0.1:80'
</pre>

Нагружаем сервис
```
docker run -d --net=host -it httpd:alpine sh -c "while true; do ab -n50 127.0.0.1/probe; sleep 3; done"```{{execute}}
