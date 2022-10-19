Применим настройки Simple TLS подключения. Simple TLS - односторонняя проверка клиентом сертификата сервера

Уточните параметры генерируемого сертификата в файле

`simple-params.env`{{open}}

Значение параметра SIMPLE_URL должно присутствовать в alt_names сертификата

`oc process -f simple.yml --param-file simple-params.env -o yaml > conf.yml
oc apply -f conf.yml
export $(cat simple-params.env | xargs)`{{execute}}

Выполним запрос. В результате увидим ошибку SSL Handshake, т.к. клиент не доверяет самоподписанному серверному
сертификату

`curl -v https://${SIMPLE_URL}`{{execute}}

`curl: (60) SSL certificate problem: self signed certificate`

Добавим сертификат в перечень доверенных и запрос будет обработан успешно. В логах Ingress Proxy видим успешный запрос
через порт 3000

`curl -v --cacert ./certs/crt.pem https://${SIMPLE_URL}`{{execute}}

`oc logs $(oc get pods -o name | grep ingress | head -n 1)`{{execute}}

`[2022-10-05T20:56:15.535Z] "GET / HTTP/2" 200 - via_upstream - "-" 0 44 1 1 "10.129.0.1" "curl/7.68.0" "841d47fc-a5bb-939f-b41c-2be4fca427c2" "simple.apps.sbc-okd.pcbltools.ru" "10.128.3.112:8080" outbound|8080||server.sbercode-654d59b9-0701-4932-a22d-bb524ae4bb5b-work.svc.cluster.local 10.131.1.130:52342 10.131.1.130:3000 10.129.0.1:38002 simple.apps.sbc-okd.pcbltools.ru -`
