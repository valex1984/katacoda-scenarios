Мы можем запустить Prometheus, используя докер образ. 

## Задание

Следующая команда запускает контейнер с Prometheus-ом. 
В качестве конфигурации передаем файл prometheus.yaml. Для этого его монтируем в контейнер нужное место. 
Данные будут хранится на диске, в директории /prometheus/data. Для этого предварительно создадим ее и примонтируем внутрь контейнера

```
mkdir -p /prometheus/data
docker run -d --net=host \
    -v /root/prometheus.yaml:/etc/prometheus/prometheus.yml \
    -v /prometheus/data:/prometheus \
    --name prometheus-server \
    prom/prometheus
```{{execute}}

После запуска, по ссылке: [dashboard](https://[[HOST_SUBDOMAIN]]-9090-[[KATACODA_HOST]].environments.katacoda.com/) будет доступен UI Prometheus-а.
