Теперь инструментируем сервис метриками. 

Добавим файл metrics.py, в котором воспользуемся клиентской библиотекой прометеуса для того, чтобы отдавать метрики. Скорее всего для разных фреймворков уже существуют готовые плагины, но мы воспользуемся голой библиотекой, чтобы немного разобраться, как все работает под капотом. 

В данном коде мы определяем 2 метрики: 
* гистограмма времени ответа, с метками method и endpoint. И названием метрики app_request_latency_seconds  - время ответа в секундах
* счетчик запросов - app_request_count. Метки: method, endpoint, http_status.

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


Создаем middleware, которое выполняется до запроса и после. 
До запроса запоминаем время его начала. 
После запроса высчитываем request_latency и инкрементим количество запросов, передавая нужные метки.

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

Как видим, клиентская библиотека прометеуса за нас решает проблемы с тем, какие бакеты используются для гистограммы. И нам не нужно самим вычислять на клиенте все данные и распределять их по бакетам.


Регистрируем middleware
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

Добавляем /metrics путь. Для того, чтобы отдать данные в формате прометеуса опять используем библиотечную функцию.

<pre class="file" data-filename="./app/app.py" data-target="insert" data-marker="if __name__ == '__main__':">

@app.route('/metrics')
def metrics():
    from prometheus_client import generate_latest
    return generate_latest()

if __name__ == '__main__':
</pre>

Регистрируем middleware

<pre class="file" data-filename="./app/app.py" data-target="insert" data-marker="if __name__ == '__main__':">
if __name__ == '__main__':
    register_metrics(app)
</pre>

После того, как инструментировали код, давайте пересоберем приложение

```
docker build -t app:metrics app/
```{{execute}}


Запускаем приложение
```
docker kill app-v1
docker run -d --net=host --name=app-metrics app:metrics 
```{{execute}}


Проверяем, что оно работает и /probe может нам ответить
```
curl localhost/probe
```{{execute}}
```

Проверяем, что метрики в формате прометеуса появились
curl localhost/metrics
```{{execute}}
