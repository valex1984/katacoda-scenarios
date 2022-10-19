Настраиваем HTTP соединение. Это самая простая реализация, но она допустима только для отладки на тестовых стендах

Заполните доменное имя, которое будет использоваться для доступа к сервису, в файле

`easy-params.env`{{open}}

Важно! Здесь и далее не изменяйте заполненную часть доменного имени, допишите произвольный префикс

Доступное имя хоста можно получить с помощью команды

`oc get ingresses.config/cluster -o jsonpath={.spec.domain}`{{execute}}

Применяем конфиги Openshift
`oc process -f easy.yml --param-file easy-params.env -o yaml > conf.yml
oc apply -f conf.yml
export $(cat easy-params.env | xargs)`{{execute}}

Проверяем соединение

`curl -v http://${EASY_URL}`{{execute}}

В выводе команды curl видим код ответа 200, в логах istio-proxy - успешно обработанный запрос

`oc logs $(oc get pods -o name | grep server | head -n 1 | cut -d '/' -f2) -c istio-proxy`{{execute}}

`[2022-10-05T20:18:30.387Z] "- - -" 0 - - - "-" 1503 600 15005 - "-" "-" "-" "-" "127.0.0.1:8080" inbound|8080|| 127.0.0.1:45842 10.131.1.124:8080 10.128.0.1:44094 - -`
