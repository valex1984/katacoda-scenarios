#!/bin/bash

[[ -f /root/envs ]] && source /root/envs || \
    { jq --null-input --arg error "envs not exists, environment fail" '{"error": $error }' && exit 1 }

faas_fn1_out=$(curl $OPENFAAS_URL/function/fn1)
gravitee_fn1_out=$(curl http://localhost:32100/gateway/serverless)
gravitee_fn2_out=$(curl -H @/root/apikey http://localhost:32100/gateway/fn2)

jq --null-input \
--arg faas_fn1_out "$faas_fn1_out" \
--arg gravitee_fn1_out "$gravitee_fn1_out" \
--arg gravitee_fn2_out "$gravitee_fn2_out" \
'{"faas_fn1_out": $faas_fn1_out, 
"gravitee_fn1_out": $gravitee_fn1_out,
"gravitee_fn2_out": $gravitee_fn2_out
}'| jq -n '.results |= [inputs]'