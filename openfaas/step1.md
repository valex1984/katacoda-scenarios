### Создание serverless функции OpenFaas
Для создания структуры директорий новой функции из темплейта выполним команду:
`faas-cli new --lang python3-sbercode apiv1`{{execute}}
Данная команда ищет темплейт с имененем python3-sbercode (мы скачали его при подготовке окружения) и создает на его основе скелет функции в текущей директории. Результат можно посмотреть в директории apiv1

Выполним сборку и деплой функции командой:
`faas-cli up -f apiv1.yml`{{execute}}

Проверить статус можно командой:
`kubectl get po -n openfaas-fn`{{execute}}
Дождемся, пока статус пода станет Ready
```
NAME                   READY   STATUS    RESTARTS   AGE
apiv1-794f59b5fd-448pd   1/1     Running   0          14s
```