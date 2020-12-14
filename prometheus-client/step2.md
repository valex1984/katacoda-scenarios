Теперь инструментируем сервис метриками. 

<pre class="file" data-filename="./app/metrics.py" data-target="replace">
import time
from prometheus_client import Counter, Histogram, Info
from flask import request

METRICS_REQUEST_LATENCY = Histogram(
    "app_request_latency_seconds", "Application Request Latency", ["method", "endpoint"]
)

METRICS_REQUEST_COUNT = Counter(
    "app_request_count",
    "Application Request Count",
    ["method", "endpoint", "http_status"],
)

METRICS_INFO = Info("app_version", "Application Version")
</pre>

<pre class="file" data-filename="./app/metrics.py" data-target="append">

def before_request():
    request._prometheus_metrics_request_start_time = time.time()

def after_request(response):
    request_latency = time.time() - request._prometheus_metrics_request_start_time
    METRICS_REQUEST_LATENCY.labels(request.method, request.path).observe(
        request_latency
    )
    METRICS_REQUEST_COUNT.labels(
        request.method, request.path, response.status_code
    ).inc()
    return response

</pre>

<pre class="file" data-filename="./app/metrics.py" data-target="append">
def register_metrics(app, app_version=None, app_config=None):
    app.before_request(before_request)
    app.after_request(after_request)
    METRICS_INFO.info({"version": "1", "config": "develop"})
</pre>

<pre class="file" data-filename="./app/app.py" data-target="insert" data-marker="from flask import Flask, abort">
from flask import Flask, abort

from metrics import register_metrics
</pre>

<pre class="file" data-filename="./app/app.py" data-target="insert" data-marker="if __name__ == '__main__':">

@app.route('/metrics')
def metrics():
    from prometheus_client import generate_latest
    return generate_latest()

if __name__ == '__main__':
</pre>

<pre class="file" data-filename="./app/app.py" data-target="insert" data-marker="if __name__ == '__main__':">
if __name__ == '__main__':
    register_metrics(app)
</pre>

```
docker build -t app:metrics app/
```{{execute}}


```
docker kill app-v1
docker run -d --net=host app:metrics --name app-metrics
```{{execute}}


```
curl localhost/probe
```{{execute}}
```

curl localhost/metrics
```{{execute}}
