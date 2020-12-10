## Дашборд

Дашборд Prometheus доступ [здесь](https://[[HOST_SUBDOMAIN]]-9090-[[KATACODA_HOST]].environments.katacoda.com/)

В дашборде можно посмотреть статус по различным target здесь [/targets](https://[[HOST_SUBDOMAIN]]-9090-[[KATACODA_HOST]].environments.katacoda.com/targets)

## PromQL и запросы в Prometheus


Например, `node_network_receive_bytes`{{copy}} состояние диска. 
А запрос `node_cpu`{{copy}} покажет состояние cpu.

Все метрики доступны тут: [the metrics endpoint](https://[[HOST_SUBDOMAIN]]-9100-[[KATACODA_HOST]].environments.katacoda.com/metrics) .
