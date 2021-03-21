#!/bin/bash

docker run -it --mount type=bind,source=/usr/local/bin/verify.py,target=/verify.py --mount type=bind,source=/root/results.txt,target=/results.txt python:3.7-slim python /verify.py --for-robot
