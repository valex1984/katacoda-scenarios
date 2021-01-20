#!/bin/bash
docker run -d --net=host -it httpd:alpine sh -c "while true; do ab -n50 127.0.0.1/probe; sleep 0; done"
