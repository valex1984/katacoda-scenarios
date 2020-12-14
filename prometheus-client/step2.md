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


<pre class="file" data-filename="./app/app.py" data-target="replace">
import os
import json
import random
import time

from flask import Flask, abort

from metrics import register_metrics

app = Flask(__name__)

FAIL_RATE=float(os.environ.get('FAIL_RATE', '0.01'))
SLOW_RATE=float(os.environ.get('SLOW_RATE', '0.01'))

def do_staff():
    time.sleep(random.gammavariate(alpha=3, beta=.1))

def do_slow():
    time.sleep(random.gammavariate(alpha=30, beta=0.3))

@app.route('/probe')
def probe():
    if random.random() < FAIL_RATE:
        abort(500)
    if random.random() < SLOW_RATE:
        do_slow()
    else:
        do_staff()
    return "I'm ok! I'm not alcoholic"

@app.route('/metrics')
def metrics():
    from prometheus_client import generate_latest
    return generate_latest()

if __name__ == "__main__":
    register_metrics(app)
    app.run(host='0.0.0.0', port='80', debug=True)
</pre>

```
docker build -t app:metrics app/
```{{execute}}


```
docker run -d --net=host app:metrics
```{{execute}}
