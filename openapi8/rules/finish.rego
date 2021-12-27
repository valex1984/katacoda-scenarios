package sbercode

allow[msg] {
	res := input.results[_]
	res.result == "pass"
	msg := "[OK] документация апи в формате swagger присутствует"
}

deny[msg] {
	res := input.results[_]
	res.result == "fail"
	msg := "[ERROR] документация апи в формате swagger отсутствует"
}

error[msg] {
	msg := input.error
}
