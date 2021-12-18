package sbercode

default fn2_ok = false

fn2_ok = true {
	res := input.results[_]
	res.gravitee_fn2_retcode == "200"
}

fn2_ok = true {
	res := input.results[_]
	res.gravitee_fn2_retcode == "429"
}

allow[msg] {
	res := input.results[_]
	res.faas_fn1_out == "changed"
	msg := sprintf("[OK] Результат работы  функции fn1, вызов через gw OpenFaaS: %s", [res.faas_fn1_out])
}

deny[msg] {
	res := input.results[_]
	res.faas_fn1_out != "changed"
	msg := sprintf("[ERROR] Результат работы  функции fn1, вызов через gw OpenFaaS: %s", [res.faas_fn1_out])
}

allow[msg] {
	res := input.results[_]
	res.gravitee_fn1_out == "changed"
	msg := sprintf("[OK] Результат работы  функции fn1, вызов через gw gravitee: %s", [res.gravitee_fn1_out])
}

deny[msg] {
	res := input.results[_]
	res.gravitee_fn1_out != "changed"
	msg := sprintf("[ERROR] Результат работы  функции fn1, вызов через gw gravitee: %s", [res.gravitee_fn1_out])
}

allow[msg] {
	res := input.results[_]
	fn2_ok
	msg := sprintf("[OK] Результат работы  функции fn2, вызов через gw gravitee: %s", [res.gravitee_fn2_out])
}

deny[msg] {
	res := input.results[_]
	fn2_ok == false
	msg := sprintf("[ERROR] Результат работы  функции fn2, вызов через gw gravitee: %s", [res.gravitee_fn2_out])
}

error[msg] {
	msg := input.error
}
