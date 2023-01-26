#!/bin/bash -x 
PS1=1
source ~/.bashrc

DONE_FILE=/usr/local/etc/autostart.sh.done

docker-compose -f /usr/local/prepare/postgres.yaml up -d

touch $DONE_FILE
