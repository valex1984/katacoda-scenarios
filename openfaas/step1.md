### Создание serverless функции OpenFaas
Для создания структуры директорий новой функции из готового образа выполним команду:
`faas-cli deploy --image=openfaas/cows:latest --name=cow`{{execute}}

Дождемся, пока наша функция запустится в k8s
`kubectl -n openfaas-fn wait --for=condition=ContainersReady --timeout=5m --all pods`{{execute}}

И затем вызовем нашу функцию

`echo 20 | faas-cli invoke cow`{{execute}}

 пример вывода функции:
 ```
  |  \___________________________
 |   ___________________________
 |  /                       /
 |  |                      /
 |  |                     /
 |  |            (__)    /
 |  |            (oo)   /
 |  |            _\/_  /
 |  |           /   ==%
 |  |          /   ==%
 |  |     *---<_  / /
 |  |          / /
 |  |         / /
 |  |        ~ ~
 |  |
 |  |       Moowgli
 |  |
/    \
```