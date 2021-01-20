#!/bin/bash
docker run -d --net=host -it httpd:alpine sh -c "while true; do ab -n50 127.0.0.1:8000/probe; sleep 0; done"
