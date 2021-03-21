#!/bin/bash
[ -f /tmp/loadsh.lock ] && exit 1

touch /tmp/loadsh.lock

docker run -d --net=host -it httpd:alpine sh -c "while true; do ab -n100 127.0.0.1:8000/probe; done"
