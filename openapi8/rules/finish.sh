#!/bin/bash

API_URL=http://localhost:32100
FILE=~/httpbin-1-0-0.json

# API_URL="http://localhost:8083"
# FILE="../root/httpbin-1-0-0.json"


api_id=$(cat $FILE|jq -r '.id')

#get api_key plan id
swagger=$(curl -s -u admin:admin \
    $API_URL/management/organizations/DEFAULT/environments/DEFAULT/apis/$api_id/pages|jq -r '.[] |select( .type | contains("SWAGGER"))' )


[[ ! -z "$swagger" ]] && result="pass" || result="fail"

jq --null-input --arg result "$result" '{"result": $result}'| jq -n '.results |= [inputs]'