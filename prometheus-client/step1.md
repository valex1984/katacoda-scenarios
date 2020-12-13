Сконфигурируем Prometheus

<pre class="file" data-filename="app.py" data-target="replace">
import os
import json
import random
import time

from flask import Flask, abort

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

if __name__ == "__main__":
    app.run(host='0.0.0.0', port='80', debug=True)
</pre>

<pre class="file" data-filename="Dockerfile" data-target="replace">
FROM python:3.7-slim

EXPOSE 8080
COPY requirements.txt /requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

COPY app.py /app.py
COPY metrics.py /metrics.py

CMD ["python", "/app.py"]
</pre>

<pre class="file" data-filename="requirements.txt" data-target="replace">
Flask==1.1.2
prometheus-client==0.7.1
</pre>

Запускаем сервис:
```
docker build -t app:v1 .
```{{execute}}

```
docker run -d --net=host app:v1
```{{execute}}

После запуска, по ссылке: [app](https://[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com/probe) можем смотреть на ответ от сервера. 

Либо с помощью curl:

```
curl localhost/probe
```{{execute}}

Запускаем прометеус: 

```
docker run -d --net=host \
     -v /root/prometheus.yaml:/etc/prometheus/prometheus.yml \
     prom/prometheus
```{{execute}}
