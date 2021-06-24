#!/bin/bash

validate.sh || exit 1

read -p "Enter token: " token

# change json variable value if you want to have custom json output
json=$(verify.sh)

result=$(echo $json | \
curl -s -d @- -w %{http_code}  \
-H "Authorization: Bearer $token" -H "Content-Type: application/json" \
-X POST https://bootcamp.pcbltools.ru/services/result-service/save)

[ "$result" = "200" ] && echo -en "\e[32mOK\e[0m\n" && exit 0

echo -en "\e[91mCould not send results. Try again with logging enabled. Copy logs from /root/exercise/send.log and send them to our support team.\e[0m\n"

read -p "(Logging enabled) Enter token: " token

echo $json | \
curl -s -v -d @-  \
-H "Authorization: Bearer $token" -H "Content-Type: application/json" \
-X POST https://bootcamp.pcbltools.ru/services/result-service/save > /tmp/send.log 2>&1

cp /tmp/send.log /root/

echo -en "\e[91mLogs created at /root/send.log\e[0m\n"
