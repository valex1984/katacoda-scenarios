package sbercode

allow[msg] {
	res := input.results[_]
	res.gravitee_apiv1_out == "Hello from OpenFaaS!"
	msg := sprintf("[OK] Результат работы  функции apiv1, вызов через gw gravitee: %s", [res.gravitee_apiv1_out])
}

deny[msg] {
	res := input.results[_]
	res.gravitee_apiv1_out != "Hello from OpenFaaS!"
	msg := sprintf("[ERROR] Результат работы  функции apiv1, вызов через gw gravitee: %s", [res.gravitee_apiv1_out])
}

allow[msg] {
	res := input.results[_]
	res.gravitee_apiv2_out == "Version_2"
	msg := sprintf("[OK] Результат работы  функции apiv1, вызов через gw gravitee: %s", [res.gravitee_apiv2_out])
}

deny[msg] {
	res := input.results[_]
	res.gravitee_apiv2_out != "Version_2"
	msg := sprintf("[ERROR] Результат работы  функции apiv1, вызов через gw gravitee: %s", [res.gravitee_apiv2_out])
}
error[msg] {
	msg := input.error
}
