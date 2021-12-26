package sbercode

test_allow_retcode {
    count(allow) == 1 with input as {"results":[{"httpbin_retcode": "200"}]}
}

test_deny_retcode {
    count(deny) == 1 with input as {"results":[{"httpbin_retcode": "404"}]}
}


test_allow_headers {
    count(allow) == 1 with input as {"results":[{"httpbin_header_count": "0"}]}
}

test_deny_headers {
    count(deny) == 1 with input as {"results":[{"httpbin_header_count": "2"}]}
}
