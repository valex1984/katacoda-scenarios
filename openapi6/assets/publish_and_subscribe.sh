#!/bin/bash


API_URL=http://localhost:32100
FILE=serverless-example-1-0-0.json
api_id=$(cat $FILE|jq -r '.id')

#import api
curl -s -u admin:admin \
    -H "Content-Type:application/json;charset=UTF-8" \
    -d @$FILE \
    $API_URL/management/organizations/DEFAULT/environments/DEFAULT/apis/import

#start api
curl  -s -u admin:admin -X POST \
    $API_URL/management/organizations/DEFAULT/environments/DEFAULT/apis/$api_id?action=START

#get plan id
plan_id=$(curl -s -u admin:admin \
    $API_URL/management/organizations/DEFAULT/environments/DEFAULT/apis/$api_id|jq -r '.plans[0].id')

#create application
app_id=$(curl -s -u user:password -X POST \
     -H "Content-Type:application/json;charset=UTF-8" \
     -d '{"name":"Demo Application","description":"Client for serverless api"}' \
    $API_URL/management/organizations/DEFAULT/environments/DEFAULT/applications/|jq -r '.id')
[[ -z "$app_id"  || "$app_id" == "null" ]] && echo "[ERROR] cannot create application"

#create subscription
subscr_id=$(curl -s -u user:password -X POST \
      $API_URL/management/organizations/DEFAULT/environments/DEFAULT/applications/$app_id/subscriptions/?plan=$plan_id|jq -r '.id')
[[ -z "$subscr_id"  || "$subscr_id" == "null" ]] && echo "[ERROR] cannot create subscribtion"

curr_date="$(date '+%Y-%m-%dT00:00:00.000Z')"
end_date="$(date -d "1 month" '+%Y-%m-%dT00:00:00.000Z')"
key=$(cat /proc/sys/kernel/random/uuid)

#approve subscription
curl -s -u admin:admin -XPOST \
     -H "Content-Type:application/json;charset=UTF-8" \
     -d '{"accepted": true,"customApiKey":"'"$key"'","starting_at":"'"$curr_date"'","ending_at":"'"$end_date"'"}' \
      $API_URL/management/organizations/DEFAULT/environments/DEFAULT/apis/$api_id/subscriptions/$subscr_id/_process

echo "X-Gravitee-Api-Key:$key" > apikey
sleep 3

echo -e "\n[INFO] done"