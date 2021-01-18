Запускаем прометеус

Сначала запустим прометеус. Для этого необходимо создать конфигурационной файл. 

В конфигурационном файле добавляем глобальные настройки и настройки, связанные со сбором метрики. 
Глобальные настройки:

scrape_interval: 15s - это интервал, с которым прометеус будет ходить за метриками в таргеты по умолчанию. 

Настройки, связанные со собором метрик.
Добавим задачу (job-y) с именем prometheus, которая использует механизм обнаружения сервисов (service discovery) на основе файлов. С частотой раз в 10 секунд прометеус будет перечитывать yml файлы из директории /targets и добавлять к себе таргеты из этих файлов.

<pre class="file" data-filename="prometheus.yml" data-target="replace">
global:
  scrape_interval:     15s
  evaluation_interval: 15s
scrape_configs:
- job_name: prometheus
  file_sd_configs:
    - files:
      - '/targets/*.yml'
      refresh_interval: 10s
</pre>


Запустим прометеус, использя докер и официальный образ prom/prometheus. Примонитируем внутрь контейнера конфигурационный файл и директорию targets

```
docker run -d --net=host \
   -v /root/prometheus.yml:/etc/prometheus/prometheus.yml \
   -v /root/targets:/targets\
   prom/prometheus
```{{execute}}

Проверить, работает ли прометеус можно зайдя по ссылке на его дашборд. В разделе targets будет пусто, и там появятся записи, как только мы добавим файлы конфигруации в директорию targets на диске.

Дашборд Prometheus доступ [здесь](https://[[HOST_SUBDOMAIN]]-9090-[[KATACODA_HOST]].environments.katacoda.com/)
