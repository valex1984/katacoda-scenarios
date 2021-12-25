package sbercode

allow[msg] {
	res := input.results[_]
	res.count == "3"
	msg := sprintf("[OK] Результат работы  функции : %s", [res.fout])
}

deny[msg] {
	res := input.results[_]
	res.count != "3"
	msg := sprintf("[ERROR] Результат работы  функции : %s", [res.fout])
}


error[msg] {
	msg := input.error
}
