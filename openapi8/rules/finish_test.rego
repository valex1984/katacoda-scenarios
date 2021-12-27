package sbercode

test_allow {
    count(allow) == 1 with input as {"results":[{"result": "pass"}]}
}

test_deny {
    count(deny) == 1 with input as {"results":[{"result": "fail"}]}
}
