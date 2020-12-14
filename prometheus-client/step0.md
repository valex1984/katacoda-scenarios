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
</pre>

```
docker run -d --net=host \
   -v /root/prometheus.yml:/etc/prometheus/prometheus.yml \
   -v /root/targets:/targets\
   prom/prometheus
```{{execute}}
