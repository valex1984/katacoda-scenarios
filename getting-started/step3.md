Чтобы собрать системные метрики хоста (CPU, Mem, Disk), необходимо запустить Node Exporter. Это специальный агент, который отдает системные метрики хоста в формате Prometheus.

## Задание

Запустим Node Exporter с помощью docker-a. Для того, чтобы агент корректно работал, ему необходимо примонтировать в контейнер /proc и /sys директории.

```
docker run -d \
  -v "/proc:/host/proc" \
  -v "/sys:/host/sys" \
  -v "/:/rootfs" \
  --net="host" \
  --name=promethus \
  quay.io/prometheus/node-exporter:v1.0.1 \
    -collector.procfs /host/proc \
    -collector.sysfs /host/sys \
    -collector.filesystem.ignored-mount-points "^/(sys|proc|dev|host|etc)($|/)"
```{{execute}}

Сырые метрики в консоле можно увидеть, если сделать запрос `curl localhost:9100/metrics`{{execute}}
