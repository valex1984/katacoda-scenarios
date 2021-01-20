#!/bin/bash
docker run -d --net=host -it httpd:alpine sh -c "while true; do ab -n100 127.0.0.1:8000/probe; done"
