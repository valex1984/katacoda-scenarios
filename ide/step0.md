запустим ide

`mkdir -p ~/workspace && \
    docker run -p 8443:8443 -d \
    --name=code-server \
    -e PUID=$(id -u) \
    -e PGID=$(id -g) \
    -e TZ=Europe/Moscow \
    -v $HOME/workspace:/config/workspace \
    linuxserver/code-server:4.23.1`{{execute}}


откроем в браузере [ide]([[UUID_SUBDOMAIN]]-8443-[[HOST]]/)
