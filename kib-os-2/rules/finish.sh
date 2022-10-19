#!/bin/bash
PS1=1
source /root/.bashrc

function url {
    grep "$1" "/root/$2-params.env" | cut -d'=' -f2
}

function san {
    grep "$1" "/root/certs/req.cnf" | wc -l
}

# Проверка наличия URL для вызова
EASY_URL=$(url 'EASY_URL' 'easy')
SIMPLE_URL=$(url 'SIMPLE_URL' 'simple')
MUTUAL_URL=$(url 'MUTUAL_URL' 'mutual')
# Проверка SAN сертификата
SIMPLE_SAN=$(san $SIMPLE_URL)
MUTUAL_SAN=$(san $MUTUAL_URL)
# Проверка HTTP вызова
EASY_RESULT="$(curl -o /dev/null -s -w "%{http_code} %{errormsg}\n" http://${EASY_URL})"
SIMPLE_RESULT="$(curl -o /dev/null --cacert ./certs/crt.pem -s -w "%{http_code} %{errormsg}\n" https://${SIMPLE_URL})"
MUTUAL_RESULT="$(curl -o /dev/null --cacert ./certs/crt.pem --cert ./certs/crt.pem --key ./certs/key.pem -s -w "%{http_code} %{errormsg}\n" https://${MUTUAL_URL})"
# Проверка конфигов Openshift
EASY_ROUTE=$(oc describe routes | grep ${EASY_URL} | wc -l)
SIMPLE_ROUTE=$(oc describe routes | grep ${SIMPLE_URL} | wc -l)
MUTUAL_ROUTE=$(oc describe routes | grep ${MUTUAL_URL} | wc -l)
SIMPLE_GW=$(oc describe gateways | grep ${SIMPLE_URL} | wc -l)
MUTUAL_GW=$(oc describe gateways | grep ${MUTUAL_URL} | wc -l)
SIMPLE_VS=$(oc describe virtualservices | grep ${SIMPLE_URL} | wc -l)
MUTUAL_VS=$(oc describe virtualservices | grep ${MUTUAL_URL} | wc -l)

jq --null-input \
--arg EASY_URL "$EASY_URL" \
--arg SIMPLE_URL "$SIMPLE_URL" \
--arg MUTUAL_URL "$MUTUAL_URL" \
--arg SIMPLE_SAN "$SIMPLE_SAN" \
--arg MUTUAL_SAN "$MUTUAL_SAN" \
--arg EASY_RESULT "$EASY_RESULT" \
--arg SIMPLE_RESULT "$SIMPLE_RESULT" \
--arg MUTUAL_RESULT "$MUTUAL_RESULT" \
--arg EASY_ROUTE "$EASY_ROUTE" \
--arg SIMPLE_ROUTE "$SIMPLE_ROUTE" \
--arg MUTUAL_ROUTE "$MUTUAL_ROUTE" \
--arg SIMPLE_VS "$SIMPLE_VS" \
--arg MUTUAL_VS "$MUTUAL_VS" \
--arg SIMPLE_GW "$SIMPLE_GW" \
--arg MUTUAL_GW "$MUTUAL_GW" \
'{
    "url": {"easy": $EASY_URL,"simple": $SIMPLE_URL,"mutual": $MUTUAL_URL,},
    "san": {"simple": $SIMPLE_SAN,"mutual": $MUTUAL_SAN,},
    "curl":{"easy": $EASY_RESULT,"simple": $SIMPLE_RESULT,"mutual": $MUTUAL_RESULT,},
    "route":{"easy": $EASY_ROUTE,"simple": $SIMPLE_ROUTE,"mutual": $MUTUAL_ROUTE,},
    "gw":{"simple": $SIMPLE_GW,"mutual": $MUTUAL_GW,},
    "vs":{"simple": $SIMPLE_VS,"mutual": $MUTUAL_VS,},
}'