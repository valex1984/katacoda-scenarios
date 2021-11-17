## Запуск  кластера kubernetes
Для того, чтобы запустить кластер кубернетеса запустим скрипт: 

`launch.sh`{{execute}}
## Установка OpenFaaS
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
## Авторизация в OpenFaaS
Выполним авторизацию консольной утилитой faas-cli в портал OpenFaaS.
Пароль получаем с помощью kubectl из секрета basic-auth в неймспейсе openfaas и передаем его в stdin команде faas-cli login  
`PASSWORD=$(kubectl -n openfaas get secret basic-auth -o jsonpath="{.data.basic-auth-password}" | base64 --decode) && echo $PASSWORD |faas-cli login --username admin -s`{{execute}}

пример вывода:  
*Calling the OpenFaaS server to validate the credentials...
WARNING! You are not using an encrypted connection to the gateway, consider using HTTPS.
credentials saved for admin http://falling-sound:31112*  

Мы получаем предупреждение о незащищенном соединении с gateway, т.к. осуществляем доступ по http через NodePort. При промышленном использовании рекомендуется использовать шифрованное https соединение c кластером.

На этом настройка окружения успешно завершена. Далее попробуем написать и запустить на нем свою первую serverless функцию.