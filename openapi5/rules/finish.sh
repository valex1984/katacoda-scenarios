#!/bin/bash

[[ ! -f /root/envs ]] && jq --null-input --arg error "envs not exists, environment fail" '{"error": $error }' && exit 1 || source /root/envs


#let's ratelimit our fn
for i in {1..10}; do tmp="$(curl -s -H @apikey http://localhost:32100/gateway/fn2)"; done
gravitee_fn2_out="$(curl -s -H @apikey http://localhost:32100/gateway/fn2)"
gravitee_fn2_retcode="$(curl -o /dev/null -s -w "%{http_code}\n"  -H @apikey http://localhost:32100/gateway/fn2)"
limit_header_count="$(curl -s -I -H @apikey http://localhost:32100/gateway/fn2|grep X-Rate-Limit|wc -l)"

jq --null-input \
--arg gravitee_fn2_out "$gravitee_fn2_out" \
--arg gravitee_fn2_retcode "$gravitee_fn2_retcode" \
--arg limit_header_count "$limit_header_count" \
'{"gravitee_fn2_out": $gravitee_fn2_out,
"gravitee_fn2_retcode": $gravitee_fn2_retcode,
"limit_header_count": $limit_header_count
}'| jq -n '.results |= [inputs]'