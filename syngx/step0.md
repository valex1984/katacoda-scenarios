
запустим контейнер, конфиг используем свой
`docker run --name syngx -d -p 8080:8080 -v ${PWD}/syngx.conf:/opt/syngx/conf/syngx.conf  syngx/syngx:3.0.0`{{execute}}

UI доступен [здесь]([[UUID_SUBDOMAIN]]-8080-[[HOST]]/) 
открывается в соседнем окне, но не открывается во фрейме, вероятно связано с настройками безопасности
