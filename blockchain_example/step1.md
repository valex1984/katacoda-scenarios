В учебном примере мы создадим отдельную директорию хранилища ключей в текущей директории. По умолчнию geth сохраняет ключи в домашней директории в папке ~/.ethereum/keystore  

При создании нового аккаунта (кошелька) geth попросит ввести пароль для шифрования приватного ключа вашего аккаунта. В учебном примере мы сохраняем пароль в файл.  

ВАЖНО! Для реальных аккаунтов пароль (и приватный ключ) должны быть надежно защищены.

`mkdir -p ~/keystore && rm -rf ~/keystore/* && echo 123 > ~/password`{{execute}}

Создадим новый аккаунт, файл ключа для удобства переименуем в 'mykeyfile':

`geth --password ~/password --keystore ~/keystore account new && mv ~/keystore/$(ls ./keystore) ~/keystore/mykeyfile`{{execute}}

Адрес кошелька будет указан в поле "Public address of the key:"

Посмотрим содержимое файла ключа (данные хранятся в формате JSON):
`cat ~/keystore/mykeyfile | jq -C`{{execute}}  

В поле "address" указан Ethereum-адрес (часть публичного ключа), а в поле "crypto" — зашифрованный паролем приватный ключ и параметры шифрования.  
Теперь попробуем расшифровать приватный ключ, зная пароль. Установим библиотеку eth-tester: 

`pip install eth-tester`{{execute}} 

Считываем файл ключа и, указав пароль, расшифровываем приватный ключ:  

`getPrivateKey.py`{{open}}

Запускаем:

`python ~/getPrivateKey.py`{{execute}} 

Получим адрес из расшифрованного приватного ключа. Для этого добавим блок кода в исходный файл:  
<pre class="file" data-filename="./getPrivateKey.py" data-target="insert" data-marker="##end Of First Block##">

account = w3.eth.account.from_key(bin_private_key)
address = w3.to_checksum_address(account.address)
print(f"Ethereum address: {address}")
</pre>

Заново запустим и убеждаемся, что адрес совпадает с адресом из предыдущего шага:  

`python ~/getPrivateKey.py`{{execute}} 