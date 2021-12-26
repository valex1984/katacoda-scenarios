package sbercode

test_fn2_allow_ret_429 {
    count(allow) == 1 with input as {"results":[{"gravitee_fn2_out": "Rate limit exceeded ! You reach the limit of 5 requests per 1 minutes","gravitee_fn2_retcode": "429"}]}
}

test_fn2_deny_ret_429 {
    count(deny) == 1 with input as {"results":[{"gravitee_fn2_retcode": "401"}]}
}

test_fn2_deny_5 {
    count(deny) == 1 with input as {"results":[{"gravitee_fn2_out": "Rate limit exceeded ! You reach the limit of 3 requests per 1 minutes"}]}
}

test_fn2_deny_headers {
    count(deny) == 1 with input as {"results":[{"limit_header_count": "0"}]}
}