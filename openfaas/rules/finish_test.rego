package sbercode

test_apiv1_allow {
    count(allow) == 1 with input as {"results":[{"gravitee_apiv1_out": "Hello from OpenFaaS!"}]}
}

test_apiv1_deny {
    count(deny) == 1 with input as {"results":[{"gravitee_apiv1_out": "err"}]}
}

test_apiv2_allow {
    count(allow) == 1 with input as {"results":[{"gravitee_apiv2_out": "Version_2"}]}
}

test_apiv2_deny {
    count(deny) == 1 with input as {"results":[{"gravitee_apiv2_out": "err"}]}
}