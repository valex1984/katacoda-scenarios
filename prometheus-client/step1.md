Теперь давайте создадим артефакты для запуска контейнеризованного приложения. Для этого нам понадобится файл с описанием зависимостей для Python и Dockerfile.


Откройте вкладку файла ./app/Dockefile в редакторе и введите в него код ниже, либо нажмите кнопку "Copy to Editor".

<pre class="file" data-filename="./app/Dockerfile" data-target="replace">
FROM python:3.7-slim
COPY requirements.txt /requirements.txt
COPY pip.conf /etc/pip.conf
RUN pip install --no-cache-dir -r requirements.txt
COPY . /app
CMD ["python", "/app/app.py"]
</pre>

Откройте вкладку файла ./app/requirements.txt в редакторе и введите в него код ниже, либо нажмите кнопку "Copy to Editor". Это файл с описанием зависимостей для сервиса

<pre class="file" data-filename="./app/requirements.txt" data-target="replace">
Flask==1.1.2
prometheus-client==0.7.1
</pre>

Откройте вкладку файла ./app/pip.conf в редакторе и введите в него код ниже, либо нажмите кнопку "Copy to Editor". Это файл с описанием откуда брать зависимости

<pre class="file" data-filename="./app/pip.conf" data-target="replace">
[global]
index-url = http://nexus:8081/repository/pypi/simple
trusted-host = nexus
</pre>

