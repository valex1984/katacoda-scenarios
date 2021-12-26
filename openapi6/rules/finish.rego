package sbercode

allow[msg] {
	res := input.results[_]
	res.before_count == res.after_count
	res.before_count != ""
	msg := "[OK] Количество вызовов функции не увеличивается"
}

deny[msg] {
	res := input.results[_]
	res.before_count != res.after_count
	msg := sprintf("[ERROR] Количество вызовов функции увеличивается, до теста %s после теста %s. Кеширование не работает",  [res.before_count, res.after_count] )
}

allow[msg] {
	res := input.results[_]
	res.gravitee_fn2_retcode == "200"
	msg := sprintf("[OK] Результат работы  функции fn2, вызов через gw gravitee: %s", [res.gravitee_fn2_out])
}

deny[msg] {
	res := input.results[_]
	res.gravitee_fn2_retcode != "200"
	msg := sprintf("[ERROR] Результат работы  функции fn2, вызов через gw gravitee: %s", [res.gravitee_fn2_out])
}

error[msg] {
	msg := input.error
}
