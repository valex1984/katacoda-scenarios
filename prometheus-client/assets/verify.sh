#!/bin/bash

RPS=`awk 'NR==1' /root/results.txt  | awk -F: '{print $2}' | sed -e 's/ //g'`
LATENCY=`awk 'NR==2' /root/results.txt  | awk -F: '{print $2}' | sed -e 's/ //g'`

if (( $RPS >= 6  &&  $RPS <= 8)) ; then RPS_OK=1; else RPS_OK=0; fi
if (( $LATENCY >= 300  &&  $LATENCY <= 400)) ; then LATENCY_OK=1; else LATENCY_OK=0; fi

[[ $RPS_OK == 1 && $LATENCY_OK == 1 ]] && echo '{"allow":["OK"], "deny":[]}'
[[ $RPS_OK == 1 && $LATENCY_OK == 1 ]] || echo '{"allow":[], "deny":["FAILED"]}'
