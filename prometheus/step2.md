Мы можем запустить Prometheus, используя докер образ. 

## Задание

Следующая команда запускает контейнер с Prometheus-ом. 
В качестве конфигурации передаем файл prometheus.yaml. 

```
docker run -d --net=host \
     -v /root/prometheus.yaml:/etc/prometheus/prometheus.yml \
     prom/prometheus
```{{execute}}

После запуска, по ссылке: [dashboard](https://[[HOST_SUBDOMAIN]]-9090-[[KATACODA_HOST]].environments.katacoda.com/) будет доступен UI Prometheus-а.
