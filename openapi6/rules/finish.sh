#!/bin/bash

[[ ! -f /root/envs ]] && jq --null-input --arg error "envs not exists, environment fail" '{"error": $error }' && exit 1 || source /root/envs

gravitee_fn2_out="$(curl -s -H @apikey http://localhost:32100/gateway/fn2)"
gravitee_fn2_retcode="$(curl -o /dev/null -s -w "%{http_code}\n" -H @apikey http://localhost:32100/gateway/fn2)"

#check if cache configured
before_count=$(faas-cli list|grep fn2|cut -f 2)
for i in {1..10}; do a="$(curl -s -H @apikey http://localhost:32100/gateway/fn2)"; done
#faas stats updates every 5 seconds, we need next value
sleep 5
after_count=$(faas-cli list|grep fn2|cut -f 2)

jq --null-input \
--arg before_count "$before_count" \
--arg after_count "$after_count" \
--arg gravitee_fn2_out "$gravitee_fn2_out" \
--arg gravitee_fn2_retcode "$gravitee_fn2_retcode" \
'{"before_count": $before_count, 
"after_count": $after_count,
"gravitee_fn2_out": $gravitee_fn2_out,
"gravitee_fn2_retcode": $gravitee_fn2_retcode
}'| jq -n '.results |= [inputs]'