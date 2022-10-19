#!/bin/bash -x
PS1=1
source ~/.bashrc

OUT_FILE=~/creds.yaml
DONE_FILE=/usr/local/etc/k8s.sh.done

_user=student
infra_project=infra
work_project=work

infra_context=${infra_project}-${_user}
work_context=${work_project}-${_user}

oc config use-context ${infra_context}
curr_project=$(oc project -q)
