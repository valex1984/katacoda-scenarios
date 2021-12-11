#!/bin/bash

[[ ! -f /root/envs ]] && jq --null-input --arg error "envs not exists, environment fail" '{"error": $error }' && exit 1 || source /root/envs

faas_fn1_out="$(curl -s $OPENFAAS_URL/function/fn1)"
gravitee_fn1_out="$(curl -s http://localhost:32100/gateway/serverless)"
gravitee_fn2_out="$(curl -s -H @/root/apikey http://localhost:32100/gateway/fn2)"

jq --null-input \
--arg faas_fn1_out "$faas_fn1_out" \
--arg gravitee_fn1_out "$gravitee_fn1_out" \
--arg gravitee_fn2_out "$gravitee_fn2_out" \
'{"faas_fn1_out": $faas_fn1_out, 
"gravitee_fn1_out": $gravitee_fn1_out,
"gravitee_fn2_out": $gravitee_fn2_out
}'| jq -n '.results |= [inputs]'