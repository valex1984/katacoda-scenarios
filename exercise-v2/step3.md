В роли аналитика изучите техническую архитектуру и топологию приложения.

## Имитация действий пользователей и нагрузки

Для имитации действий пользователей выполните команду `nohup load.sh [[HOST_IP]] > /tmp/load.log 2>&1 </dev/null &`{{execute T1}}

Вывод эмулятора нагрузки можно посмотреть во вкладке `EMU_Load`

## Изучите топологию приложения в динамике

Откройте Kiali в браузере https://[[HOST_SUBDOMAIN]]-31546-[[KATACODA_HOST]].environments.katacoda.com/

## Изучите дескрипторы основных объектов приложения

* сформировать файлы дескрипторов `all-descriptors.sh`{{execute T1}}
* открыть редакторе `productpage-v1.yaml`{{open}}
* открыть редакторе `details-main.yaml`{{open}}
* открыть редакторе `details-secondary.yaml`{{open}}
* открыть редакторе `reviews-v3.yaml`{{open}}
* открыть редакторе `ratings-v1.yaml`{{open}}
