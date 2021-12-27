package sbercode

test_allow_200_get {
    count(allow) == 1 with input as {"results":[{"httpbin_200_get": "200"}]}
}

test_deny_200_get {
    count(deny) == 1 with input as {"results":[{"httpbin_200_get": "403"}]}
}

test_allow_200_post {
    count(allow) == 1 with input as {"results":[{"httpbin_200_post": "200"}]}
}

test_deny_200_post {
    count(deny) == 1 with input as {"results":[{"httpbin_200_post": "403"}]}
}

test_allow_200_delete_apikey {
    count(allow) == 1 with input as {"results":[{"httpbin_200_del_apikey": "200"}]}
}

test_deny_200_delete_apikey {
    count(deny) == 1 with input as {"results":[{"httpbin_200_del_apikey": "403"}]}
}

test_allow_403_delete {
    count(allow) == 1 with input as {"results":[{"httpbin_403_del": "403"}]}
}

test_deny_403_delete {
    count(deny) == 1 with input as {"results":[{"httpbin_403_del": "200"}]}
}
