<iframe width="560" height="315" src="https://www.youtube-nocookie.com/embed/UsxIDNNIwa0" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>

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
    return "3:2\n"

if __name__ == '__main__':
    app.run(host='0.0.0.0', port='8000', debug=True)
</pre>

Укажите в коде правильное значение счета матча Россия-Финляндия
