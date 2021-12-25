#!/bin/bash

[[ ! -f /root/envs ]] && jq --null-input --arg error "envs not exists, environment fail" '{"error": $error }' && exit 1 || source /root/envs

OUT=/tmp/res

[[ -f $OUT ]] && rm -f $OUT

for i in {1..3}; do echo "$(curl -s http://localhost:32100/gateway/api/v1)" >> $OUT; done

count="$(cat  $OUT |grep Version_2|wc -l)"
fout=$(cat $OUT)
jq --null-input --arg count "$count"  --arg fout "$fout" '{"count": $count, "fout": $fout}'| jq -n '.results |= [inputs]'