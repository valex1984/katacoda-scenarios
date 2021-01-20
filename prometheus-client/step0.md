Теперь давайте запустим Prometheus. Prometheus - это система мониторинга с открытым кодом, работающая по pull-модели сбора метрик. Prometheus также предоставляет возможность запрашивать данные с помощью языка запросов PromQL. 

Prometheus написан на go и распространяется в виде бинарного запускаемого файла. Чтобы запустить Prometheus достаточно запустить исполняемый файл и передать ему конфигурацию. 

Минимальный конфиг для Prometheus-а представляется собой файл в формате yaml. И в файле есть две секции: global - для глобальных настроек и scrape_configs - конфиги скрапинга. 

Prometheus использует pull модель сбора метрик, а это значит, что с некоторой периодичностью Prometheus ходит в сервисы, которые мониторит и забирает у них метрики в формате Prometheus expose format по протоколу HTTP. Это процесс называется скрапингом (scaping, от английского scrape - выскабливать). А сервисы, которые должен мониторить Prometheus таргетами (targets от англисйского target - цель). Поэтому основные настройки Prometheus-а, которые мы будем использовать в конфиге, будут относится к этому процессу.  

Глобальные настройки. 

    scrape_interval: 15s - это интервал, с которым Prometheus будет ходить за метриками в таргеты по умолчанию. 

Настройки, описывающие, конкретные таргеты, находятся в разделе scrape_configs. Это раздел представляет собой список задач (job-ов). Задача в контексте Prometheus - это коллекция таргетов, имеющих одно и то же предназначение, плюс настройки скрапинга. Например, приложение может быть в виде 3 экземпляров сервисов, расположенных на разных нодах. Т.е. в терминах Prometheus для мониторинга этого приложения ему нужно 3 таргета.  

Параметры задачи (job). Прежде всего название job_name. А для описания списка таргетов воспользуемся статическим конфигом - т.е. опишем список таргетов прямо в файле конфигурации. 

Также у Prometheus есть другие возможность получать список таргетов динамически с помощью различных методов обнаружения (service discovery): например, из kubernetes, consul, файлов и т.д.

Вот пример простейшего конфига для Prometheus-a. Введите строки ниже в файл prometheus.yml. Вы можете сделать это вручную или нажав кнопку "Copy to Editor".

<pre class="file" data-filename="prometheus.yml" data-target="replace">
global:
  scrape_interval:     15s
scrape_configs:
- job_name: app
  static_configs:
    - targets: ['localhost:8000']
</pre>

Давайте запустим сервис Prometheus-a. Для этого воспользуемся докером и официальным образом prom/prometheus. Примонитируем внутрь контейнера конфигурационный файл и директорию targets.

```
docker run -d --net=host \
   -v /root/prometheus.yml:/etc/prometheus/prometheus.yml \
   -v /root/targets:/targets\
   prom/prometheus
```{{execute}}

Проверить, работает ли Prometheus можно зайдя по ссылке на его дашборд. В разделе targets будет пусто, и там появятся записи, как только мы добавим файлы конфигруации в директорию targets на диске.

Дашборд Prometheus доступ [здесь](https://[[HOST_SUBDOMAIN]]-9090-[[KATACODA_HOST]].environments.katacoda.com/)