package sbercode

test_fn2_allow_ret_429 {
    count(allow) == 1 with input as {"results":[{"gravitee_fn2_out": "ratelimit here","gravitee_fn2_retcode": "200"}]}
}

test_fn2_deny_ret_401 {
    count(deny) == 1 with input as {"results":[{"gravitee_fn2_out": "access denyed with 401","gravitee_fn2_retcode": "401"}]}
}

test_fn1_allow_faas {
    count(allow) == 1 with input as {"results":[{"faas_fn1_out":"changed","gravitee_fn2_out": "ratelimit here","gravitee_fn2_retcode": "401"}]}
}

test_fn1_deny_faas {
    count(deny) == 1 with input as {"results":[{"faas_fn1_out":"changed123","gravitee_fn2_out": "ratelimit here","gravitee_fn2_retcode": "200"}]}
}

test_fn1_allow_gravitee {
    count(allow) == 1 with input as {"results":[{"gravitee_fn1_out":"changed","gravitee_fn2_out": "ratelimit here","gravitee_fn2_retcode": "401"}]}
}

test_fn1_deny_gravitee {
    count(deny) == 1 with input as {"results":[{"gravitee_fn1_out":"changed123","gravitee_fn2_out": "ratelimit here","gravitee_fn2_retcode": "200"}]}
}