package sbercode

default fn2_ok = false

fn2_ok = true {
	res := input.results[_]
	res.httpbin_retcode == "200"
}

allow[msg] {
	res := input.results[_]
	fn2_ok
	msg := sprintf("[OK] сервис httpbin доступен")
}

deny[msg] {
	res := input.results[_]
	fn2_ok == false
	msg := sprintf("[ERROR] сервис httpbin не доступен")
}

error[msg] {
	msg := input.error
}
