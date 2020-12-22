Создадим с сервис, который будет эмулировать работу реального приложения.

По пути /probe этот сервис будет отвечать с некоторой задержкой, которая будет определяться с помощью некоторого распределения вероятностей, и также с некоторой вероятностью приложения иногда будет 500тить. 

Сервис напишем на питоне:

<pre class="file" data-filename="./app/app.py" data-target="replace">
import os
import json
import random
import time

from flask import Flask, abort

app = Flask(__name__)

FAIL_RATE=float(os.environ.get('FAIL_RATE', '0.05'))
SLOW_RATE=float(os.environ.get('SLOW_RATE', '0.00'))

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

if __name__ == '__main__':
    app.run(host='0.0.0.0', port='80', debug=True)
</pre>

Давайте его запустим с помощью докера, для этого нам понадобится Dockerfile

<pre class="file" data-filename="./app/Dockerfile" data-target="replace">
FROM python:3.7-slim
COPY requirements.txt /requirements.txt
RUN pip install --no-cache-dir -r requirements.txt
COPY . /app
CMD ["python", "/app/app.py"]
</pre>

И файл с описанием зависимостей для сервиса

<pre class="file" data-filename="./app/requirements.txt" data-target="replace">
Flask==1.1.2
prometheus-client==0.7.1
</pre>


С помощью команды docker build собираем образ с меткой app:v1

```
docker build -t app:v1 app/
```{{execute}}


Запускаем это приложение в хост-сети, имя контейнера пусть будет app-v1

```
docker run -d --net=host --name=app-v1 app:v1 
```{{execute}}


Проверить работоспособность можно с помощью curl.

```
curl localhost/probe
```{{execute}}

Пока наш сервис просто работает, но он никак не инструментирован метриками и эндпоинт /metrics, в который мог бы ходить прометеус не реализован.
