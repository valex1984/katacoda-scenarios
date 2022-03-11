###  Создание новой версии
Предположим, текущая версия нашего демонстрационного api Содержит ошибку. Мы хотим выкатить фикс с использованием канареечного деплоя.
Создадим еще одну функцию из темплейта, которая будет возвращать текст "Version_2":

`faas-cli new --lang python3-sbercode apiv2 && sed -i 's/Hello from OpenFaaS!/Version_2/' ~/apiv2/handler.py &&  sed -i 's/Hello from OpenFaaS!/Version_2/' ~/apiv2/handler_test.py && faas-cli up -f apiv2.yml`{{execute}}

Дождемся, пока статус пода станет Ready.  
`kubectl wait -n openfaas-fn --for=condition=ContainersReady --timeout=5m --all pods`{{execute}}  

### Публикация новой версии

Канареечный деплой предполагает, что на новую версию функции будет перенаправлен небольшой % запросов для оценки стабильности работы.
Перенаправим 10% траффика на новую версию.

Откроем интерфейс gravitee apim по ссылке [gravitee ](https://[[HOST_SUBDOMAIN]]-32100-[[KATACODA_HOST]].environments.katacoda.com/)  и авторизуемся в нем  
```
права администратора
user: admin
pasword: admin

```

Переходим на страницу нашего апи
![App_](./assets/openapi4-0.png)
Добавляем еще один бэкенд 
![App_](./assets/openapi4-1.png)
Указываем URL http://gateway.openfaas:8080/function/apiv2 и вес 1
![App_](./assets/openapi4-1-1.png) 
Переходим на страницу редактирования текущей версии
![App_](./assets/openapi4-1-2.png)
Вес текущей версии указываем 9
![App_](./assets/openapi4-1-3.png)
Далее переходим в редактирование группы бэкенд серверов
![App_](./assets/openapi4-2.png)
И меняем тип балансировки на "Weighted Round-Robin". 
![App_](./assets/openapi4-3.png) 
Таким образом 90% траффика остается на текущей версии и 10% направляется на новую.  

Сохраняем изменения и публикуем их, нажав "deploy" вверху экрана.
![App_](./assets/openapi4-4.png) 

Проверим настройки, выполнив 20 обращений к апи
`for i in {1..20}; do echo "$(curl -s  http://localhost:32100/gateway/api/v1)"; done`{{execute}}

пример вывода:
```
Hello from OpenFaaS!
Version_2
Hello from OpenFaaS!
Hello from OpenFaaS!
Hello from OpenFaaS!
Hello from OpenFaaS!
Hello from OpenFaaS!
Hello from OpenFaaS!
Hello from OpenFaaS!
Hello from OpenFaaS!
Hello from OpenFaaS!
Version_2
Hello from OpenFaaS!
Hello from OpenFaaS!
Hello from OpenFaaS!
Hello from OpenFaaS!
Hello from OpenFaaS!
Hello from OpenFaaS!
Hello from OpenFaaS!
Hello from OpenFaaS!
```
Заметим, что 10% запросов попадают на новую версию согласно настройкам.

После успешного тестирования новой версии на нее перенаправляется 100% траффика, а старая версия выводится из эксплуатации. 
Для этого переходим на страницу управления эндпоинтами и корректируем настройки.
![App_](./assets/openapi4-5.png) 
Применяем изменения и проверяем, что весь траффик направляется на новую версию.
`for i in {1..10}; do echo "$(curl -s  http://localhost:32100/gateway/api/v1)"; done`{{execute}}

пример вывода:

```
Version_2
Version_2
Version_2
Version_2
Version_2
Version_2
Version_2
Version_2
Version_2
Version_2
```