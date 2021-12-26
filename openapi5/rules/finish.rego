package sbercode

allow[msg] {
	res := input.results[_]
	res.gravitee_fn2_retcode == "429"
	contains(res.gravitee_fn2_out ,"limit of 5 requests per 1 minutes")
	msg := sprintf("[OK] Результат работы  функции fn2, вызов через gw OpenFaaS: %s", [res.gravitee_fn2_out])
}

deny[msg] {
	res := input.results[_]
	res.gravitee_fn2_retcode != "429"
	msg := sprintf("[ERROR] код возврата  функции fn2, вызов через gw OpenFaaS: %s", [res.gravitee_fn2_retcode])
}

deny[msg] {
	res := input.results[_]
	contains(res.gravitee_fn2_out ,"limit of 5 requests per 1 minutes") == false
	msg := sprintf("[ERROR] Не настроен лимит 5 запросов/мин. Ответ функции fn2, вызов через gw OpenFaaS: %s", [res.gravitee_fn2_out])
}

deny[msg] {
	res := input.results[_]
	res.limit_header_count != "3"
	msg := "[ERROR] Не включена настройка на api gateway по добавлению ratelimit заголовков в ответе"
}
error[msg] {
	msg := input.error
}
