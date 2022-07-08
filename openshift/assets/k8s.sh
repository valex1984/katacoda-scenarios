#!/bin/bash -x 
PS1=1
source ~/.bashrc
oc apply -f /usr/local/k8s
