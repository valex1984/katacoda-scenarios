Напишем и запустим сервис, который будет эмулировать работу реального приложения. А в следующем шаге инструментируем, чтобы он отдавал метрики для Prometheus.

Сервис напишем на Python. По пути /probe этот сервис будет отвечать с некоторой задержкой, эмулирующей работу. Длительность задержки будет определяться с помощью некоторого распределения вероятностей, и также с некоторой вероятностью приложения иногда будет отдавать 500ый статус код HTTP. 

Откройте закладку файла app.py в редакторе и введите в него код на Python ниже, либо нажмите кнопку "Copy to Editor". Это основной файл нашего приложения.

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
    time.sleep(random.gammavariate(alpha=1.5, beta=.1))

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
    return "OK"

if __name__ == '__main__':
    app.run(host='0.0.0.0', port='8000', debug=True)
</pre>

Теперь давайте запустим этот сервис с помощью Docker. Для этого нам понадобится файл с описанием зависимостей для Python и Dockerfile.


Откройте вкладку файла ./app/Dockefile в редакторе и введите в него код ниже, либо нажмите кнопку "Copy to Editor".

<pre class="file" data-filename="./app/Dockerfile" data-target="replace">
FROM python:3.7-slim
COPY requirements.txt /requirements.txt
RUN pip install --no-cache-dir -r requirements.txt
COPY . /app
CMD ["python", "/app/app.py"]
</pre>

Откройте вкладку файла ./app/requirements.txt в редакторе и введите в него код ниже, либо нажмите кнопку "Copy to Editor". Это файл с описанием зависимостей для сервиса

<pre class="file" data-filename="./app/requirements.txt" data-target="replace">
Flask==1.1.2
prometheus-client==0.7.1
</pre>

С помощью команды docker build собираем локальный образ с меткой app:v1. Докер образ будет хранится локально.

```
docker build -t app:v1 app/
```{{execute}}

Запускаем это приложение с помощью docker-a в хост-сети, имя контейнера пусть будет app-v1

```
docker run -d --net=host --name=app-v1 app:v1 
```{{execute}}


Проверить работоспособность можно с помощью curl.

```
curl localhost:8000/probe
```{{execute}}

Наш сервис должен ответить текстом "ОК" в консоли.

Пока наш сервис не предоставляет никаких метрик в Prometheus, но в шаге 3 мы исправим это.
