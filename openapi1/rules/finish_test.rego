package sbercode

test_allow {
    count(allow) == 1 with input as {"results":[{"httpbin_retcode": "200"}]}
}

test_deny {
    count(deny) == 1 with input as {"results":[{"httpbin_retcode": "404"}]}
}

