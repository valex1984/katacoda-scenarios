Mutual TLS - взаимная проверка клиентом и сервером сертификатов друг друга

Уточните параметры генерируемого сертификата в файле

`mutual-params.env`{{open}}

Значение параметра MUTUAL_URL должно присутствовать в alt_names сертификата

`oc process -f mutual.yml --param-file mutual-params.env -o yaml > conf.yml
oc apply -f conf.yml
export $(cat mutual-params.env | xargs)`{{execute}}

При попытке вызова без клиентского сертификата получим ошибку SSL Handshake

`curl -v --cacert ./certs/crt.pem https://${MUTUAL_URL}`{{execute}}

`curl: (56) OpenSSL SSL_read: error:1409445C:SSL routines:ssl3_read_bytes:tlsv13 alert certificate required, errno 0`

Отправим запрос с сертификатом клиента. Встроенный в Windows curl не умеет работать с сертификатами, выпущенными
OpenSSL

`curl -v --cacert ./certs/crt.pem --cert ./certs/crt.pem --key ./certs/key.pem https://${MUTUAL_URL}`{{execute}}

В логах Ingress Proxy видим успешный запрос через порт 3001

`oc logs $(oc get pods -o name | grep ingress | head -n 1)`{{execute}}

`[2022-10-05T20:56:50.761Z] "GET / HTTP/2" 200 - via_upstream - "-" 0 44 1 1 "10.129.0.1" "curl/7.68.0" "b8fae816-16a6-962b-99a6-8ad560058177" "mutual.apps.sbc-okd.pcbltools.ru" "10.128.3.112:8080" outbound|8080||server.sbercode-654d59b9-0701-4932-a22d-bb524ae4bb5b-work.svc.cluster.local 10.131.1.130:52342 10.131.1.130:3001 10.129.0.1:49604 mutual.apps.sbc-okd.pcbltools.ru -`