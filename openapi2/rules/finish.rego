package sbercode

allow[msg] {
	res := input.results[_]
	res.httpbin_retcode == "200"
	msg := "[OK] сервис httpbin доступен через api gateway"
}

deny[msg] {
	res := input.results[_]
	res.httpbin_retcode != "200"
	msg := "[ERROR] сервис httpbin не доступен через api gateway"
}

allow[msg] {
	res := input.results[_]
	res.httpbin_header_count == "0"
	msg := "[OK] В ответе отсутствуют заголовки X-Gravitee*"
}

deny[msg] {
	res := input.results[_]
	res.httpbin_header_count != "0"
	msg := "[ERROR]  В ответе присутствуют заголовки X-Gravitee*"
}

error[msg] {
	msg := input.error
}
