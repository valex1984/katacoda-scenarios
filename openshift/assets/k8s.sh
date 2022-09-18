#!/bin/bash -x 
PS1=1
source ~/.bashrc

OUT_FILE=~/creds

_user=student
infra_project=infra
work_project=work
infra_context=${infra_project}-${_user}
work_context=${work_project}-${_user}
oc config set-context ${infra_context}
curr_project=$(oc project -q)

pgpass=$(cat /proc/sys/kernel/random/uuid)
oc create secret generic pg-postgresql --from-literal=postgres-password="$pgpass" --dry-run=client -oyaml \
| kubectl apply -f-
oc apply -f /usr/local/k8s -n "${curr_project}"

echo "postgres: pg.${infra_project}.svc.cluster.local:5432   user: postgres   password: $pgpass" > $OUT_FILE

oc config set-context ${work_context}
