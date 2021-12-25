package sbercode

default ok = false

ok = true {
	res := input.results[_]
	res.httpbin_retcode == "200"
}

allow[msg] {
	res := input.results[_]
	ok
	msg := "[OK] сервис httpbin доступен"
}

deny[msg] {
	res := input.results[_]
	ok == false
	msg := "[ERROR] сервис httpbin не доступен"
}

error[msg] {
	msg := input.error
}
