package sbercode

test_allow {
    count(allow) == 1 with input as {"results":[{"count": "3","fout": "Version2"}]}
}

test_deny {
    count(deny) == 1 with input as {"results":[{"count": "0","fout": "Hello from OpenFaas!"}]}
}