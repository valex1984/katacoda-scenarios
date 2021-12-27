package sbercode

allow[msg] {
	res := input.results[_]
	res.httpbin_200_get == "200"
	msg := "[OK] сервис httpbin доступен через api gateway без авторизации. Endpoint /get, тип запроса GET"
}

deny[msg] {
	res := input.results[_]
	res.httpbin_200_get != "200"
	msg := sprintf("[ERROR] запрос без авторизации на endpoint /get, тип запроса GET. Код возврата: %s", [res.httpbin_200_get])
}

allow[msg] {
	res := input.results[_]
	res.httpbin_200_post == "200"
	msg := "[OK] сервис httpbin доступен через api gateway без авторизации. Endpoint /post, тип запроса POST"
}

deny[msg] {
	res := input.results[_]
	res.httpbin_200_post != "200"
	msg := sprintf("[ERROR] запрос без авторизации на endpoint /post, тип запроса POST. Код возврата: %s", [res.httpbin_200_post])
}

allow[msg] {
	res := input.results[_]
	res.httpbin_200_del_apikey == "200"
	msg := "[OK] сервис httpbin доступен через api gateway c авторизацией. Endpoint /delete, тип запроса DELETE"
}

deny[msg] {
	res := input.results[_]
	res.httpbin_200_del_apikey != "200"
	msg := sprintf("[ERROR] запрос c авторизацией на endpoint /delete, тип запроса DELETE. Код возврата: %s", [res.httpbin_200_del_apikey])
}

allow[msg] {
	res := input.results[_]
	res.httpbin_403_del == "403"
	msg := "[OK] сервис httpbin не доступен через api gateway без авторизации. Endpoint /delete, тип запроса DELETE, код возврата 403"
}

deny[msg] {
	res := input.results[_]
	res.httpbin_403_del != "403"
	msg := sprintf("[ERROR] запрос без авторизации на endpoint /delete, тип запроса DELETE. Код возврата: %s, ожидаемый код возврата: 403", [res.httpbin_403_del])
}

error[msg] {
	msg := input.error
}
