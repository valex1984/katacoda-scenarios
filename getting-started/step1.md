Сконфигурируем Prometheus

<pre class="file" data-filename="prometheus.yml" data-target="replace">
global:
  scrape_interval:     15s
  evaluation_interval: 15s
scrape_configs:
  - job_name: 'prometheus'

    static_configs:
      - targets: ['127.0.0.1:9090', '127.0.0.1:9100']
        labels:
          group: 'prometheus'
</pre>


_9090_ - порт, по которому Prometheus отдает внутренние метрики

_9100_ - порт, по которому Node Exporter отдает свои метрики
