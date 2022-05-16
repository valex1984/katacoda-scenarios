#!/bin/bash

[[ ! -f /root/envs ]] && jq --null-input --arg error "envs not exists, environment fail" '{"error": $error }' && exit 1 || source /root/envs

gravitee_apiv1_out="$(curl -s http://localhost:32100/gateway/api/v1)"
gravitee_apiv2_out="$(curl -s http://localhost:32100/gateway/api/v2)"

jq --null-input \
--arg gravitee_apiv1_out "$gravitee_apiv1_out" \
--arg gravitee_apiv2_out "$gravitee_apiv2_out" \
'{"gravitee_apiv1_out": $gravitee_apiv1_out, 
"gravitee_apiv2_out": $gravitee_apiv2_out
}'| jq -n '.results |= [inputs]'