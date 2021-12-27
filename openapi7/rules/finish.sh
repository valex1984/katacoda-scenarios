#!/bin/bash

httpbin_200_get="$(curl -o /dev/null -s -w "%{http_code}\n" http://localhost:32100/httpbin/get)"
httpbin_200_post="$(curl -o /dev/null -s -w "%{http_code}\n" http://localhost:32100/httpbin/get)"
httpbin_200_del_apikey="$(curl -o /dev/null -s -w "%{http_code}\n" -H @apikey -XDELETE http://localhost:32100/httpbin/delete)"
httpbin_403_del="$(curl -o /dev/null -s -w "%{http_code}\n" -XDELETE http://localhost:32100/httpbin/delete)"

jq --null-input \
--arg httpbin_200_get "$httpbin_200_get" \
--arg httpbin_200_post "$httpbin_200_post" \
--arg httpbin_200_del_apikey "$httpbin_200_del_apikey" \
--arg httpbin_403_del "$httpbin_403_del" \
'{"httpbin_200_get": $httpbin_200_get, 
"httpbin_200_post": $httpbin_200_post,
"httpbin_200_del_apikey": $httpbin_200_del_apikey,
"httpbin_403_del": $httpbin_403_del
}'| jq -n '.results |= [inputs]'