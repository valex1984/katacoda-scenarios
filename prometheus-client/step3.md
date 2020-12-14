Нагружаем сервис
```
docker run --net=host -it httpd:alpine sh -c "while true; do ab -n50 127.0.0.1/probe; sleep 3; done"```{{execute}}

Запускаем прометеус


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
    metrics_path: /metrics
</pre>

```
docker run -d --net=host \
   -v /root/prometheus.yml:/etc/prometheus/prometheus.yml \
   -v /root/targets:/targets\
   prom/prometheus
```{{execute}}

<pre class="file" data-filename="./targets/app.yml" data-target="replace">
- targets:
  - localhost:80
</pre>
