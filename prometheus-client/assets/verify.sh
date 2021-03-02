#!/bin/bash

RPS=`awk 'NR==1' /root/results.txt  | awk -F: '{print $2}' | sed -e 's/ //g'`
LATENCY=`awk 'NR==2' /root/results.txt  | awk -F: '{print $2}' | sed -e 's/ //g'`

[ -z "$RPS" ] && echo "Введите не пустое значение количество запросов в секунду"
[ -z "$LATENCY" ] && echo "Введите не пустое значение квантиля 0.9 для длительности запросов"

[ -z "$RPS" ] || [ -z "LATENCY" ] && exit 1


if (( $RPS >= 6  &&  $RPS <= 8)) ; then RPS_OK=1; else RPS_OK=0; fi
if (( $LATENCY >= 300  &&  $LATENCY <= 400)) ; then LATENCY_OK=1; else LATENCY_OK=0; fi

[[ $RPS_OK == 1 && $LATENCY_OK == 1 ]] && echo '{"allow":["OK"], "deny":[]}'
[[ $RPS_OK == 1 && $LATENCY_OK == 1 ]] || echo '{"allow":[], "deny":["FAILED"]}'
