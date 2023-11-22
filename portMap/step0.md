Вот пример простейшего конфига для Prometheus-a. Введите строки ниже в файл prometheus.yml. Вы можете сделать это вручную или нажав кнопку "Copy to Editor".

<pre class="file" data-filename="prometheus.yml" data-target="replace">
global:
  scrape_interval:     15s
scrape_configs:
- job_name: app
  metrics_path: '/metrics'
  static_configs:
    - targets: ['127.0.0.1:8000']
</pre>

Давайте запустим сервис Prometheus-a. Для этого воспользуемся докером и официальным образом prom/prometheus. Примонитируем внутрь контейнера конфигурационный файл.

```
docker run -d --net=host --name=prometheus \
   -v /root/prometheus.yml:/etc/prometheus/prometheus.yml \
   prom/prometheus \
   --config.file=/etc/prometheus/prometheus.yml \
   --storage.tsdb.path=/prometheus \
   --web.console.libraries=/usr/share/prometheus/console_libraries \
   --web.console.templates=/usr/share/prometheus/consoles \
   --web.route-prefix=$(cat /usr/local/etc/sbercode-prefix)-9090/ \
   --web.external-url=http://127.0.0.1/$(cat /usr/local/etc/sbercode-prefix)-9090/
```{{execute}}

Проверить, работает ли Prometheus можно зайдя по ссылке на его дашборд. Дашборд Prometheus доступен [здесь](https://[[HOST_SUBDOMAIN]]-9090-[[KATACODA_HOST]].environments.katacoda.com/)


Еще один на порту 9091
```
docker run -d -p 9091:9090 --name=prometheus2 \
   -v /root/prometheus.yml:/etc/prometheus/prometheus.yml \
   prom/prometheus \
   --config.file=/etc/prometheus/prometheus.yml \
   --storage.tsdb.path=/prometheus \
   --web.console.libraries=/usr/share/prometheus/console_libraries \
   --web.console.templates=/usr/share/prometheus/consoles
```{{execute}}

Дашборд Prometheus доступен [здесь]([[UUID_SUBDOMAIN]]-9091-[[HOST]]/)

Еще один на порту 9092
```
docker run -d -p 9092:9090 --name=prometheus3 \
   -v /root/prometheus.yml:/etc/prometheus/prometheus.yml \
   prom/prometheus \
   --config.file=/etc/prometheus/prometheus.yml \
   --storage.tsdb.path=/prometheus \
   --web.console.libraries=/usr/share/prometheus/console_libraries \
   --web.console.templates=/usr/share/prometheus/consoles
```{{execute}}

Дашборд Prometheus доступен [здесь]([[UUID_SUBDOMAIN]]-9092-[[HOST]]/)

тест с сабурлом [здесь]([[UUID_SUBDOMAIN]]-9092-[[HOST]]/ui/here)