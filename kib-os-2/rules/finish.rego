package sbercode

allow[msg] {
	res := input.url
    regex.match(".+\\.apps\\.sbc-okd\\.pcbltools\\.ru", res.easy)
	msg := "[OK] заполнен URL для HTTP-соединения"
}

deny[msg] {
	res := input.url
    not regex.match(".+\\.apps\\.sbc-okd\\.pcbltools\\.ru", res.easy)
	msg := "[ERROR] не заполнен URL для HTTP-соединения"
}

allow[msg] {
	res := input.url
    regex.match(".+\\.apps\\.sbc-okd\\.pcbltools\\.ru", res.simple)
	msg := "[OK] заполнен URL для Simple TLS"
}

deny[msg] {
	res := input.url
    not regex.match(".+\\.apps\\.sbc-okd\\.pcbltools\\.ru", res.simple)
	msg := "[ERROR] не заполнен URL для Simple TLS"
}

allow[msg] {
	res := input.url
    regex.match(".+\\.apps\\.sbc-okd\\.pcbltools\\.ru", res.mutual)
	msg := "[OK] заполнен URL для Mutual TLS"
}

deny[msg] {
	res := input.url
    not regex.match(".+\\.apps\\.sbc-okd\\.pcbltools\\.ru", res.mutual)
	msg := "[ERROR] не заполнен URL для Mutual TLS"
}

allow[msg] {
	res := input.san
    res.simple == "1"
	msg := "[OK] URL для Simple TLS присутствует в SAN сертификата"
}

deny[msg] {
	res := input.san
    res.simple != "1"
	msg := "[ERROR] URL для Simple TLS отсутствует в SAN сертификата"
}

allow[msg] {
	res := input.san
    res.mutual == "1"
	msg := "[OK] URL для Mutual TLS присутствует в SAN сертификата"
}

deny[msg] {
	res := input.san
    res.mutual != "1"
	msg := "[ERROR] URL для Mutual TLS отсутствует в SAN сертификата"
}

allow[msg] {
	res := input.route
    res.easy == "1"
	msg := "[OK] создан Route для HTTP-соединения"
}

deny[msg] {
	res := input.route
    res.easy != "1"
	msg := "[ERROR] не создан Route для HTTP-соединения"
}

allow[msg] {
	res := input.route
    res.simple == "1"
	msg := "[OK] создан Route для Simple TLS"
}

deny[msg] {
	res := input.route
    res.simple != "1"
	msg := "[ERROR] не создан Route для Simple TLS"
}

allow[msg] {
	res := input.route
    res.mutual == "1"
	msg := "[OK] создан Route для Mutual TLS"
}

deny[msg] {
	res := input.route
    res.mutual != "1"
	msg := "[ERROR] не создан Route для Mutual TLS"
}

allow[msg] {
	res := input.gw
    res.simple == "1"
	msg := "[OK] создан Gateway для Simple TLS"
}

deny[msg] {
	res := input.gw
    res.simple != "1"
	msg := "[ERROR] не создан Gateway для Simple TLS"
}

allow[msg] {
	res := input.gw
    res.mutual == "1"
	msg := "[OK] создан Gateway для Mutual TLS"
}

deny[msg] {
	res := input.vs
    res.mutual != "1"
	msg := "[ERROR] не создан Virtual Service для Mutual TLS"
}

allow[msg] {
	res := input.vs
    res.simple == "1"
	msg := "[OK] создан Virtual Service для Simple TLS"
}

deny[msg] {
	res := input.vs
    res.simple != "1"
	msg := "[ERROR] не создан Virtual Service для Simple TLS"
}

allow[msg] {
	res := input.vs
    res.mutual == "1"
	msg := "[OK] создан Virtual Service для Mutual TLS"
}

deny[msg] {
	res := input.gw
    res.mutual != "1"
	msg := "[ERROR] не создан Gateway для Mutual TLS"
}

allow[msg] {
	res := input.curl
    res.easy=="200"
	msg := "[OK] успешная проверка HTTP-соединения"
}

error[msg] {
	res := input.curl
    res.easy!="200"
	msg := concat(" ", ["[ERROR] ошибка при проверке HTTP соединения. Код ошибки",res.easy])
}

allow[msg] {
	res := input.curl
    res.simple=="200"
	msg := "[OK] успешная проверка Simple TLS"
}

error[msg] {
	res := input.curl
    res.simple!="200"
	msg := concat(" ", ["[ERROR] ошибка при проверке Simple TLS. Код ошибки",res.simple])
}

allow[msg] {
	res := input.curl
    res.mutual=="200"
	msg := "[OK] успешная проверка Mutual TLS"
}

error[msg] {
	res := input.curl
    res.mutual!="200"
	msg := concat(" ", ["[ERROR] ошибка при проверке Mutual TLS. Код ошибки",res.mutual])
}

error[msg] {
	msg := input.error
}

#https://dev2-85.pcbltools.ru/ui/epifantsev218/kib-os-2?xAPILaunchService=https%3A%2F%2Fmaster-sbs-review.sbsdev.ru%2Fxapi%2F&xAPILaunchKey=eyJhbGciOiJIUzUxMiJ9.eyJpc3MiOiJhdXRoLnNiZXJiYW5rLXNjaG9vbC5ydSIsImF1ZCI6WyJkZWZhdWx0IiwiYXV0aCIsInNicy1nZW5lcmFsIl0sInVzZXJfaWQiOjI1LCJyZWdpc3RyYXRpb24iOiI2NDIxNDFlMi00ZTczLTQ3YWQtODUxYS1iOWM2M2ZiMzI4M2QifQ.h4wOBn2YTJXzxaL1vCgcdvJHDvIGygT6ipUTq5wgwfeJxbWZWveoG6DI8tBK0wFa2OzYmKvM7MaQg3JIPwvpjQ