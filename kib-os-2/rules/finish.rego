package sbercode

allow[msg] {                                                                                                           
  msg := input.message
}

deny[msg] {                                                                                                           
  msg := input.deny
}

error[msg] {                                                                                                           
  msg := input.error
}