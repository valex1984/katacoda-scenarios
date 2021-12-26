package sbercode

test_fn2_allow_count {
    count(allow) == 1 with input as {"results":[{"before_count": "100","after_count": "100"}]}
}

test_fn2_deny_count {
    count(deny) == 1 with input as {"results":[{"before_count": "100","after_count": "200"}]}
}

test_fn2_allow_ret {
    count(allow) == 1 with input as {"results":[{"gravitee_fn2_out": "access allow with 200","gravitee_fn2_retcode": "200"}]}
}

test_fn2_deny_ret {
    count(deny) == 1 with input as {"results":[{"gravitee_fn2_out": "access denyed with 401","gravitee_fn2_retcode": "401"}]}
}