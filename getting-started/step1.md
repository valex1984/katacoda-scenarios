Сконфигурируем Prometheus

<pre class="file" data-filename="prometheus.yaml" data-target="replace">
global:
  scrape_interval:     15s
  evaluation_interval: 15s
scrape_configs:
  - job_name: 'node_exporter'
    static_configs:
      - targets: ['127.0.0.1:9090', '127.0.0.1:9100']
</pre>

_scrape_interval_ - это частота, с которой Prometheus ходит для сбора метрик

_evaluation_interval_ - это частота, с которой Prometheus вычисляет правила

_9090_ - порт, по которому Prometheus отдает внутренние метрики

_9100_ - порт, по которому Node Exporter отдает свои метрики
