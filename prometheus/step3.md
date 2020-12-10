Чтобы собрать системные метрики хоста (CPU, Mem, Disk), необходимо запустить Node Exporter. Это специальный агент, который отдает системные метрики хоста в формате Prometheus.

## Задание

Запустим Node Exporter с помощью docker-a. 

```
docker run -d --net=host prom/node-exporter
```{{execute}}

Сырые метрики в консоле можно увидеть, если сделать запрос `curl localhost:9100/metrics`{{execute}}
