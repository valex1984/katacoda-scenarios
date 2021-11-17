Для того, чтобы запустить кластер кубернетеса запустим скрипт: 

`launch.sh`{{execute}}

Далее запустим скрипт установки OpenFaaS:

`openfaas.sh`{{execute}}

скрипт выполняет следуещее:
- создает 2 неймспейса: openfaas под системные компоненты и openfaas-fn под serverless функции
- создает файл переменных окружения ~/envs
- выполняет деплой системных компонент OpenFaaS с помощью helm чарта 
- устанавливает внутренний registry в неймспейс container-registry для публикации кастомных функций
- устанавливает консольную утилиту faas-cli для взаиимодействия с OpenFaaS из комндной строки
- скачивает темплейт для создания функций на языке python в root/template
- ожидает доступность всех pod в неймспейсах openfaas, container-registry

Для установки переменных окружения используем созданный файл:

`source ~/envs`{{execute}}

Выполним авторизацию консольной утилитой faas-cli в портал OpenFaaS:

`PASSWORD=$(kubectl -n openfaas get secret basic-auth -o jsonpath="{.data.basic-auth-password}" | base64 --decode) && echo $PASSWORD |faas-cli login --username admin -s`{{execute}}

пароль получаем с помощью kubectl из секрета basic-auth в неймспейсе openfaas и передаем в stdin команде faas-cli login