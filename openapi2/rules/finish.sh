#!/bin/bash

httpbin_retcode="$(curl -o /dev/null -s -w "%{http_code}\n" http://localhost:32100/gateway/httpbin/get)"
httpbin_header_count="$(curl -sI http://localhost:32100/gateway/httpbin/get |grep Gravitee|wc -l)"

jq --null-input \
--arg httpbin_retcode "$httpbin_retcode" \
--arg httpbin_header_count "$httpbin_header_count" \
'{"httpbin_retcode": $httpbin_retcode, 
"httpbin_header_count": $httpbin_header_count
}'| jq -n '.results |= [inputs]'