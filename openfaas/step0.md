Для  подготовки окружения запустим скрипт: 

`prepare.sh`{{execute}}

скрипт выполняет следующее:
- создает необходимые неймспейсы в kubernetes
- создает файл переменных окружения ~/envs
- выполняет деплой системных компонент OpenFaaS, registry
- устанавливает консольную утилиту faas-cli для взаимодействия с OpenFaaS из командной строки
- скачивает темплейт для создания функций на языке python в root/template

Ожидаем 2-3 мин, пока все компоненты будут успешно инсталлированы. 

Далее, для установки переменных окружения используем созданный файл:

`source ~/envs`{{execute}}
### Проверка окружения
получим список запущенных подов в кластере и убедимся что у всех статус ready

`kubectl get po -A`{{execute}}

Проверим доступ из консольного клиента к OpenFaaS 

`faas-cli list -v`{{execute}}

т.к. ни одной функции мы еще не создали, вывод будет следующий:
```
Function                        Image                                           Invocations     Replicas        CreatedAt
```
На этом настройка окружения успешно завершена. Далее попробуем запустить свою первую serverless функцию.