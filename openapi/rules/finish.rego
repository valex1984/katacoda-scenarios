package sbercode

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
  res.gravitee_fn2_out == "Hello from OpenFaaS!"
  msg := sprintf("[OK] Результат работы  функции fn2, вызов через gw gravitee: %s", [res.gravitee_fn2_out])
}

deny[msg] {  
  res := input.results[_]
  res.gravitee_fn2_out != "Hello from OpenFaaS!"
  msg := sprintf("[ERROR] Результат работы  функции fn2, вызов через gw gravitee: %s", [res.gravitee_fn2_out])
}

error[msg] {
  msg := input.error
}