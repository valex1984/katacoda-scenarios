package sbercode

default ok = false

ok = true {
	res := input.results[_]
	res.httpbin_retcode == "200"
}

allow[msg] {
	ok
	msg := "[OK] сервис httpbin доступен"
}

deny[msg] {
	ok == false
	msg := "[ERROR] сервис httpbin не доступен"
}

error[msg] {
	msg := input.error
}
